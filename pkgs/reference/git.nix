{ callPackage, python314Packages }:
callPackage ./generic-python.nix {
  service = "git";
  dependencies = with python314Packages; [
    click
    gitpython
    mcp
    pydantic
  ];
}
