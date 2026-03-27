{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "signoz-mcp-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SigNoz";
    repo = "signoz-mcp-server";
    rev = "v${finalAttrs.version}";
    sha256 = "MpbYz1gsXg7+wBaNDGljn9TuyRsYwoZ8MFgR3/GgRNk=";
  };

  vendorHash = "sha256-MKm5he3bwwJUTCJ/L986lRGN0mYaWI5rOaeQyg/QeU8=";

  postInstall = ''
    mv $out/bin/server $out/bin/signoz-mcp-server
  '';

  meta = {
    description = "MCP Server for SigNoz observability platform";
    homepage = "https://github.com/SigNoz/signoz-mcp-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ antono ];
    mainProgram = "signoz-mcp-server";
  };
})
