{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "playwright-mcp";
  version = "0.0.85";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lzG9ZVoWkGaqpqH4eH1/knfqP8RAu+QYklMUZifvI04=";
  };

  npmDepsHash = "sha256-sco3DK3BMfsNDY2wHw1DjNor4x1R6s/JZExVVhByFgk=";

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
