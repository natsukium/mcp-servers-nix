{
  pname,
  version,
  src,
  python ? null,
}:
{
  lib,
  uv2nix,
  pyproject-nix,
}:
let
  # Use Python 3.12 by default
  python' = python or lib.nixpkgs.python312;
  
  # Load the UV workspace
  workspace = uv2nix.lib.workspace.loadWorkspace { 
    workspaceRoot = src; 
  };
  
  # Create overlay from UV lock file
  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };
  
  # Base Python package set
  baseSet = lib.nixpkgs.callPackage pyproject-nix.build.packages {
    python = python';
  };
  
  # Python set with overlay applied
  pythonSet = baseSet.overrideScope overlay;
  
in
pythonSet.${pname}.overrideAttrs (old: {
  inherit pname version src;
  
  meta = (old.meta or {}) // {
    description = "MCP server for ${pname}";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
})
