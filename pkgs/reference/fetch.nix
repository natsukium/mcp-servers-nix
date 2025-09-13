{ callPackage, python313Packages }:
callPackage ./generic-python.nix {
  service = "fetch";
  # relaxing version constraints until the following issue is closed.
  # https://github.com/modelcontextprotocol/servers/issues/1136
  pythonRelaxDeps = [ "httpx" ];
  dependencies = with python313Packages; [
    markdownify
    mcp
    protego
    pydantic
    readabilipy
    requests
  ];
  doCheck = false;
}
