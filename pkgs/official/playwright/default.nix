{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.69";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-zX9RsHVInRib69N4LkG3R4TB5qjlBirpu9BBftcr92I=";
  };

  npmDepsHash = "sha256-hc5AkUTGoXxXlDW9vPpiO23QOgANJp1lX4xoaySHoK4=";

  npmWorkspace = "packages/playwright-mcp";

  dontNpmBuild = true;

  # npm workspace symlinks (e.g. node_modules/@playwright/mcp -> ../../packages/playwright-mcp)
  # become dangling after npm pack copies only the target workspace's files.
  postInstall = ''
    find $out -xtype l -delete
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    changelog = "https://github.com/microsoft/playwright-mcp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "playwright-mcp";
  };
}
