# Proper uv2nix pattern for UV-based MCP servers
# Based on https://pyproject-nix.github.io/uv2nix/usage/hello-world.html
{
  pname,
  version,
  src,
  lib,
  pkgs,
  python312,  # Use python312 for fastmcp compatibility
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
}:

let
  # Load uv workspace from the source
  workspace = uv2nix.lib.workspace.loadWorkspace { 
    workspaceRoot = src; 
  };
  
  # Create package overlay from workspace
  overlay = workspace.mkPyprojectOverlay {
    # Prefer prebuilt binary wheels - more likely to work
    sourcePreference = "wheel";
  };
  
  # Build fixups overlay for any missing metadata
  pyprojectOverrides = _final: _prev: {
    # Package-specific build fixups can go here
  };
  
  # Construct package set using pyproject-nix builders
  pythonSet = (pkgs.callPackage pyproject-nix.build.packages {
    python = python312;
  }).overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default
      overlay
      pyprojectOverrides
    ]
  );

in
# Create virtual environment for the main package
pythonSet.mkVirtualEnv "${pname}-env" workspace.deps.default
