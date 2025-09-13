{ callPackage, python312Packages }:
callPackage ./generic-python.nix {
  service = "time";
  dependencies = with python312Packages; [
    mcp
    pydantic
    tzdata
    tzlocal
  ];
  doCheck = false;
}
