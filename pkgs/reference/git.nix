{ callPackage, python312Packages }:
callPackage ./generic-python.nix {
  service = "git";
  dependencies = with python312Packages; [
    click
    gitpython
    mcp
    pydantic
  ];
}
