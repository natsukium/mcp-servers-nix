{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nd-mcp";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ufnoYszdu1vlhgit9jj9P8ugfUSdkWsll/BFyzXrELs=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/web/mcp/bridges/stdio-golang";

  vendorHash = "sha256-7JqwcenKhaOgziXfkl32qz2VrZ0zKhNJMLfvHto/Pco=";

  # Upstream builds as nd-mcp-bridge; rename for brevity
  postInstall = ''
    mv $out/bin/nd-mcp{-bridge,}
  '';

  meta = {
    description = "MCP stdio-to-WebSocket bridge for Netdata";
    homepage = "https://github.com/netdata/netdata/tree/master/src/web/mcp";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    mainProgram = "nd-mcp";
  };
})
