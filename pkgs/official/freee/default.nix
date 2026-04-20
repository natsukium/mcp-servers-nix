{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
  nix-update-script,
  nodejs-slim,
}:

let
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "freee";
    repo = "freee-mcp";
    tag = "v${version}";
    hash = "sha256-dQLlJ8eWXByX0Pb9VfH5abYBAmLDKheKWLiOTC5a74U=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "freee-mcp-deps";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      export HOME=$TMPDIR

      bun install --frozen-lockfile --no-cache --ignore-scripts --production

      mkdir -p $out
      cp -r node_modules $out/
      cp bun.lock package.json $out/

      runHook postInstall
    '';

    outputHash = "sha256-YUf3P7nhClb4yEmO8955AT+gg8Va9ZHpx6H1Zpk/uCw=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation {
  pname = "freee-mcp";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    cp -r ${deps}/node_modules .
    cp ${deps}/bun.lock .

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/freee-mcp,share}
    cp -r bin dist node_modules package.json $out/lib/freee-mcp/
    cp -r skills $out/share/

    for cmd in freee-mcp freee-remote-mcp freee-sign-mcp; do
      makeBinaryWrapper ${nodejs-slim}/bin/node $out/bin/$cmd \
        --add-flags "$out/lib/freee-mcp/bin/$cmd.js"
    done

    runHook postInstall
  '';

  passthru = {
    inherit deps;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "deps"
      ];
    };
  };

  meta = {
    description = "Model Context Protocol (MCP) server for freee API integration";
    homepage = "https://github.com/freee/freee-mcp";
    changelog = "https://github.com/freee/freee-mcp/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "freee-mcp";
  };
}
