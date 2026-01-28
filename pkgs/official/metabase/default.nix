{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "metabase-mcp";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "jerichosequitin";
    repo = "metabase-mcp";
    rev = "v1.1.4";
    hash = "sha256-it7h052gHpeEzEMuqUIM/r+FdO3ajmnXUJFIkuVC8kI=";
  };

  npmDepsHash = "sha256-PPqFZByLliWIGA5hrRfxQg0RfNBJdh1L1oCWBTJBy28=";

  meta = {
    description = "MCP server for Metabase analytics integration";
    homepage = "https://github.com/jerichosequitin/metabase-mcp";
    license = lib.licenses.mit;
    maintainers = [
      {
        github = "takeokunn";
        githubId = 11222510;
        name = "takeokunn";
      }
    ];
    mainProgram = "metabase-mcp";
  };
}
