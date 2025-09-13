{ callPackage, python312Packages }:
callPackage ./generic-python.nix {
  service = "fetch";
  # relaxing version constraints until the following issue is closed.
  # https://github.com/modelcontextprotocol/servers/issues/1126
  pythonRelaxDeps = [ "httpx" ];
  dependencies = with python312Packages; [
    markdownify
    mcp
    protego
    pydantic
    readabilipy
    requests
  ];
  doCheck = false;
}
