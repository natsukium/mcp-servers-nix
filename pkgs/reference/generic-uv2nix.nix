# Proper uv2nix pattern for UV-based MCP servers
{
  pname,
  version,
  src,
  lib,
  python311,
  uv2nix,
  pyproject-nix,
}:

let
  # Generate workspace from uv.lock
  workspace = uv2nix.lib.workspace-from-lock { 
    workspaceRoot = src; 
    lockFile = "${src}/uv.lock";
  };
  
  # Create package set from workspace
  packageSet = workspace.mkPackageSet {
    inherit python311;
    packageOverrides = {
      # Any package-specific overrides go here
    };
  };
  
in packageSet.mkVirtualenv {
  # The main package name from pyproject.toml
  inherit pname;
  
  # Root dependencies - uv2nix will handle the rest
  dependencies = [ pname ];
  
  meta = {
    description = "MCP server for ${pname}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
