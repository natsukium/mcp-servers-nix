{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  nodejs-slim,
}:

# TODO: would be great to remove this once nixpkgs
# has native build bun packages derivation
let
  version = "1.0.26";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "v${version}";
    hash = "sha256-sOyZwYB9WlPfzbrQW+krf2QDoWzei+wMJvohGi+C6B0=";
  };

  # Step 1: Fixed-output derivation for dependencies
  deps = stdenv.mkDerivation {
    pname = "context7-mcp-deps";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontBuild = true;
    dontFixup = true;

    # The cache is populated alongside node_modules so the main installPhase
    # can re-resolve with --production offline.
    #
    # --backend=copyfile avoids hardlinks from node_modules into the cache,
    # which would otherwise create disallowed self-references in the FOD.
    #
    # bun also stores symlinks like cache/<pkg>/<ver>@@@1 pointing at absolute
    # paths under $BUN_INSTALL_CACHE_DIR. The sandbox $TMPDIR differs across
    # build hosts, making the output non-deterministic, so rewrite them to
    # relative paths after copying.
    installPhase = ''
      runHook preInstall

      export HOME=$TMPDIR
      export BUN_INSTALL_CACHE_DIR=$TMPDIR/bun-cache

      bun install --frozen-lockfile --backend=copyfile

      mkdir -p $out
      cp -r node_modules $out/
      cp -r $BUN_INSTALL_CACHE_DIR $out/cache
      cp bun.lock package.json $out/

      find $out/cache -type l -lname "$BUN_INSTALL_CACHE_DIR/*" | while read -r link; do
        target=$(readlink "$link")
        rel_in_cache=''${target#$BUN_INSTALL_CACHE_DIR/}
        rel_to_cache=$(realpath --relative-to="$(dirname "$link")" "$out/cache")
        ln -sfn "$rel_to_cache/$rel_in_cache" "$link"
      done

      runHook postInstall
    '';

    # This hash represents the dependencies
    outputHash = "sha256-oHvXY8H9bFOjL1kUC61hoZ2JtgDjx9etd1iMaWb9pRE=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  # Step 2: Main build derivation
in
stdenv.mkDerivation {
  pname = "context7-mcp";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    cp -r ${deps}/node_modules .
    chmod -R u+w node_modules
    cp ${deps}/bun.lock .

    substituteInPlace node_modules/.bin/tsc \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs-slim}"

    bun run build

    runHook postBuild
  '';

  # bun lacks a `prune` command (https://github.com/oven-sh/bun/issues/3605),
  # so wipe the dev node_modules and re-resolve with `--production` using the
  # deps FOD's cache to drop devDependencies without hitting the network.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context7-mcp

    cp -r dist $out/lib/context7-mcp/

    export HOME=$TMPDIR
    export BUN_INSTALL_CACHE_DIR=${deps}/cache
    rm -rf node_modules
    bun install --production --frozen-lockfile --backend=copyfile

    cp -r node_modules $out/lib/context7-mcp/
    cp package.json $out/lib/context7-mcp/

    chmod +x $out/lib/context7-mcp/dist/index.js

    mkdir -p $out/bin
    makeWrapper $out/lib/context7-mcp/dist/index.js $out/bin/context7-mcp \
      --prefix PATH : ${lib.makeBinPath [ nodejs-slim ]} \

    runHook postInstall
  '';

  passthru = {
    inherit deps;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Up-to-date code documentation for LLMs and AI code editors";
    homepage = "https://context7.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      rec {
        github = "vaporif";
        githubId = 3934971;
        name = github;
      }
    ];
    mainProgram = "context7-mcp";
  };
}
