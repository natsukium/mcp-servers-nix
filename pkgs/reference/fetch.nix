{ callPackage, python314Packages }:
callPackage ./generic-python.nix {
  service = "fetch";
  # relaxing version constraints until the following issue is closed.
  # https://github.com/modelcontextprotocol/servers/issues/1146
  pythonRelaxDeps = [ "httpx" ];
  dependencies = with python314Packages; [
    markdownify
    mcp
    protego
    pydantic
    readabilipy
    requests
  ];
  doCheck = false;
}
