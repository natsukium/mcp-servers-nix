{ callPackage, python313Packages }:
callPackage ./generic-python.nix {
  service = "time";
  dependencies = with python313Packages; [
    mcp
    pydantic
    tzdata
    tzlocal
  ];
  doCheck = false;
}
