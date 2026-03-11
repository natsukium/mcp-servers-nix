{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  nodejs-slim,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "freee-mcp";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "freee";
    repo = "freee-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1wJts3V7DCtmZ2RGRfcr4gsNifxJW3hr9F4JH6arHaU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-o5MTWNsGBrU8ErVcu59qCX/zgZ25pXe4ZWN0Y6T0Yng=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/freee-mcp}
    cp -r bin dist node_modules package.json $out/lib/freee-mcp/

    makeWrapper ${nodejs-slim}/bin/node $out/bin/freee-mcp \
      --add-flags "$out/lib/freee-mcp/bin/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Model Context Protocol (MCP) server for freee API integration";
    homepage = "https://github.com/freee/freee-mcp";
    changelog = "https://github.com/freee/freee-mcp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "freee-mcp";
  };
})
