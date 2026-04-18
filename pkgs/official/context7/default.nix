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

    installPhase = ''
      runHook preInstall

      export HOME=$TMPDIR

      # Install dependencies
      bun install --frozen-lockfile --no-cache

      # Copy to output
      mkdir -p $out
      cp -r node_modules $out/
      cp bun.lock package.json $out/

      runHook postInstall
    '';

    # This hash represents the dependencies
    outputHash = "sha256-En6dinY9wRnlr/+IUMQS1PaAYl/V4YvqE4ib8+hunKg=";
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
    cp ${deps}/bun.lock .

    substituteInPlace node_modules/.bin/tsc \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs-slim}"

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context7-mcp

    cp -r dist $out/lib/context7-mcp/

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
