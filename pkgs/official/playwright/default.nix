{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "playwright-mcp";
  version = "0.0.84";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ijUhAxZls2QQkwNUtO7Ip51h+/I4OBqj5V7WCm8cU84=";
  };

  npmDepsHash = "sha256-Z0Ab9kB1tow5//Y3FpQ6JxzITyqtP2BksPVp0mIoX1c=";

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    changelog = "https://github.com/microsoft/playwright-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "playwright-mcp";
  };
})
