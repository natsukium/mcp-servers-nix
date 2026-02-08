{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcp-server-fetch";
  version = "2025.4.7";
  pyproject = true;

  src = fetchPypi {
    pname = "mcp_server_fetch";
    inherit version;
    hash = "sha256-VieePFXLHlBrlYypuyPtRBOUSm8jC8oh4ESu5Rc0/kc=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies =
    with python3.pkgs;
    let
      # Downgrade httpx to 0.27.2 due to proxy API breakage in 0.28
      # See: https://github.com/modelcontextprotocol/servers/issues/1146
      httpx_0_27 = httpx.overridePythonAttrs (old: rec {
        version = "0.27.2";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-98K+HS88PDFg1EGAJAayBsK3b1lHsREV5t8QxsZeZsI=";
        };
      });

      httpx-sse_with_old_httpx = httpx-sse.override {
        httpx = httpx_0_27;
      };

      # Override mcp to use the downgraded httpx
      mcp_with_old_httpx = mcp.override {
        httpx = httpx_0_27;
        httpx-sse = httpx-sse_with_old_httpx;
      };
    in
    [
      httpx_0_27
      markdownify
      mcp_with_old_httpx
      protego
      pydantic
      readabilipy
      requests
    ];

  pythonImportsCheck = [
    "mcp_server_fetch"
  ];

  meta = {
    description = "A Model Context Protocol server providing tools to fetch and convert web content for usage by LLMs";
    homepage = "https://pypi.org/project/mcp-server-fetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "mcp-server-fetch";
  };
}
