{ callPackage, python314Packages }:
callPackage ./generic-python.nix {
  service = "time";
  dependencies = with python314Packages; [
    mcp
    pydantic
    tzdata
    tzlocal
  ];
  doCheck = false;
}
