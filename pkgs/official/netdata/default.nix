{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nd-mcp";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    tag = "v${version}";
    hash = "sha256-4VjfmImrjigZwlqn/TIwjGd9Df0YMybzaxa9eQPID+I=";
  };

  sourceRoot = "${src.name}/src/web/mcp/bridges/stdio-golang";

  vendorHash = "sha256-7JqwcenKhaOgziXfkl32qz2VrZ0zKhNJMLfvHto/Pco=";

  # Upstream builds as nd-mcp-bridge; rename for brevity
  postInstall = ''
    mv $out/bin/nd-mcp-bridge $out/bin/nd-mcp
  '';

  meta = {
    description = "MCP stdio-to-WebSocket bridge for Netdata";
    homepage = "https://github.com/netdata/netdata/tree/master/src/web/mcp";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [
      {
        github = "takeokunn";
        githubId = 11222510;
        name = "takeokunn";
      }
    ];
    mainProgram = "nd-mcp";
  };
}
