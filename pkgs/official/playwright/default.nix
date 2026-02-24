{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.68";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-TPO2fUOfBWJjk2Qz7Tc5jKyPrkR8RYd1sSxWYlcx8pg=";
  };

  npmDepsHash = "sha256-ekJR38hnohiSrYxHTMmiquuCCS5h/H/T/jCe66mJ6PQ=";

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
