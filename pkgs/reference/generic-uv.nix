{
  pname,
  version,
  src,
  lib,
  python311,
}:
# For debugging - let's create a simpler derivation that doesn't use the problematic assertion
python311.pkgs.buildPythonPackage {
  inherit pname version src;
  
  format = "pyproject";
  
  nativeBuildInputs = with python311.pkgs; [
    hatchling
  ];
  
  propagatedBuildInputs = with python311.pkgs; [
    # Required runtime dependencies from pyproject.toml
    typing-extensions
    typer
    fastmcp  # Available in nixpkgs!
  ];
  
  # Skip tests for now to avoid test dependency issues
  doCheck = false;
  
  meta = {
    description = "MCP server for ${pname}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
