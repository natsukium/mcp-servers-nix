{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "tavily-mcp-server";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "tavily-ai";
    repo = "tavily-mcp";
    rev = "fea64be37d3a9589547d8c66af4fb8505fd2b265";
    hash = "sha256-gqyPeJWRvsLrkDbQYFv3mW1+IVqtWmgrcVsdDWG9JVk=";
  };

  npmDepsHash = "sha256-QsWzfIa3t0V6fH2wlyafB2B6WH7gr5nV6PS1Q4+gXNY=";

  meta = {
    description = "Official Tavily MCP Server";
    homepage = "https://github.com/tavily-ai/tavily-mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tavily-mcp";
  };
}
