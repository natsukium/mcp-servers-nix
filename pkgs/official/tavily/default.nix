{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "tavily-mcp-server";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "tavily-ai";
    repo = "tavily-mcp";
    rev = "3be0c424ed2e9132e3830aa6a8a41ba96becd6d6";
    hash = "sha256-7gFWBPtkLVKTF1FtGs4hCdaZh31CAp0dwHdTLAKbWMs=";
  };

  npmDepsHash = "sha256-0fmNDhaUJiE/XF9EJmEYv61AH8V1KvJo2xe8A0/ngGM=";

  meta = {
    description = "Official Tavily MCP Server";
    homepage = "https://github.com/tavily-ai/tavily-mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tavily-mcp";
  };
}
