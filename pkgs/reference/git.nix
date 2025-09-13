{ callPackage, python313Packages }:
callPackage ./generic-python.nix {
  service = "git";
  dependencies = with python313Packages; [
    click
    gitpython
    mcp
    pydantic
  ];
}
