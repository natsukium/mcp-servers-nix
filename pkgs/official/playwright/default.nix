{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "playwright-mcp";
  version = "0.0.80";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pIePGuIxBaHqvP6QVLzGSef0uarYE+X/rs3LWZEU22U=";
  };

  npmDepsHash = "sha256-3T4XNZSUL5sbcHmWfn9Dfigu635FACVEZ/EHSKYu1+8=";

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
