{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "playwright-mcp";
  version = "0.0.83";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pkm4kmnWgLX7wmPjL3hM3LWfkPwIVUoW3Wp/RHjX/hA=";
  };

  npmDepsHash = "sha256-+uDq8oXkxQK4SNXBNZFtd4zrun1MGeSMeiLHViaNqHY=";

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
