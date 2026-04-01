{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.70";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-dvFFG+/cYy09RjEMDIWncTNCcyaKoKH52qweYq0HHxU=";
  };

  npmDepsHash = "sha256-tyVigQYA/viB8Ycg++SfPF6WEWWulnfuJXZYOBGhhOQ=";

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
