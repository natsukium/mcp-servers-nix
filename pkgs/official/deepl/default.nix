{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "deepl-mcp-server";
  version = "1.1.0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "DeepLcom";
    repo = "deepl-mcp-server";
    rev = "55b1f3637391f795f9c3fbb32bd7ca67b875cc83";
    hash = "sha256-8P581j+oa6G9oCqQyeEeBIWCxtHTN/TkciQBDaU1hBA=";
  };

  npmDepsHash = "sha256-VLlqfO3z0gs8cZgdWaZVz+bNSi0pgU1RF/JZy+SzRhs=";

  dontNpmBuild = true;

  meta = {
    description = "MCP server for DeepL translation API";
    homepage = "https://github.com/DeepLcom/deepl-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaporif ];
    mainProgram = "deepl-mcp-server";
  };
}
