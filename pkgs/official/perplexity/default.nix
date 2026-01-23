{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "perplexity-mcp";
  version = "unstable-2025-12-18";

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "modelcontextprotocol";
    rev = "67ae52809b617712889be38d144d2ac6eef4821d";
    hash = "sha256-UdSV9xpXX6yEDgZxFu+1KfXcNNg0ilNxk/FE2eNENpI=";
  };

  npmDepsHash = "sha256-aAIH/z/5BSbLYmAc7ZyPEIoblLdHlncp8uFGFDebots=";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };

  meta = {
    description = "The official MCP server implementation for the Perplexity API Platform";
    homepage = "https://github.com/perplexityai/modelcontextprotocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "perplexity-mcp";
    platforms = lib.platforms.all;
  };
})
