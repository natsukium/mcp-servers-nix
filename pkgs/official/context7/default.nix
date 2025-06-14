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
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "v${version}";
    hash = "sha256-vtwr7q80spmMuGbdc98DX822o8uF9wTbHeA3mEGXai8=";
  };

  # Step 1: Fixed-output derivation for dependencies
  deps = stdenv.mkDerivation {
    pname = "context7-mcp-deps";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontBuild = true;
    dontFixup = true;

    env.BUN_INSTALL_CACHE_DIR = "$TMPDIR/cache";

    installPhase = ''
      mkdir -p $BUN_INSTALL_CACHE_DIR

      bun install --frozen-lockfile --no-cache --backend copyfile

      mkdir $out
      cp -r $BUN_INSTALL_CACHE_DIR $out
    '';

    outputHash = "sha256-GdWw9rA2CcJA7p4UWwz2qTQzZxpBsztAUwuVKvuuyrc=";
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

  env.BUN_INSTALL_CACHE_DIR = "${deps}/cache";

  buildPhase = ''
    runHook preBuild

    bun install

    substituteInPlace node_modules/.bin/tsc \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs-slim}"

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context7-mcp

    cp -r dist $out/lib/context7-mcp/

    # bun doesn't support the `prune` command
    # https://github.com/oven-sh/bun/issues/3605
    rm -r node_modules
    bun install --production

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
  };

  meta = {
    description = "Up-to-date code documentation for LLMs and AI code editors";
    homepage = "https://context7.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      vaporif
    ];
    mainProgram = "context7-mcp";
  };
}
