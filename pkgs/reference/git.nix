{ callPackage, python3Packages }:
callPackage ./generic-python.nix {
  service = "git";
  dependencies = with python3Packages; [
    click
    gitpython
    mcp
    pydantic
  ];
  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];
  disabledTests = [
    # nixpkgs' gitpython runs git by its store path, so the cmdline no longer
    # starts with a bare `git`.
    "test_git_add_nonexistent_file_is_git_error"
    # Looks up the console script next to sys.executable, where the check
    # phase's interpreter does not have it.
    "test_console_script_nonexistent_repository_exits_with_one_line_error"
  ];
}
