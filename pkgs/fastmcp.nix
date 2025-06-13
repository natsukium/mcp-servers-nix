# fastmcp package for nixpkgs
{ lib, python310, fetchFromGitHub }:

python310.pkgs.buildPythonPackage rec {
  pname = "fastmcp";
  version = "0.4.1";
  
  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    rev = "v${version}";  # Assuming tags are prefixed with 'v'
    hash = "sha256-0000000000000000000000000000000000000000000000000000";  # Will need to be calculated
  };
  
  format = "pyproject";
  
  nativeBuildInputs = with python310.pkgs; [
    setuptools
    wheel
  ];
  
  propagatedBuildInputs = with python310.pkgs; [
    # Dependencies from fastmcp's pyproject.toml/requirements
    httpx
    pydantic
    pydantic-settings
    python-dotenv
    typer
    # Note: mcp dependency might also need to be packaged
  ];
  
  # Skip tests for now
  doCheck = false;
  
  meta = with lib; {
    description = "The fast, Pythonic way to build MCP servers";
    homepage = "https://github.com/jlowin/fastmcp";
    license = licenses.mit;  # Assuming MIT license
  };
}
