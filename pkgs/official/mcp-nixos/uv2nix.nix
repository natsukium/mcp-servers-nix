# mcp-nixos using proper uv2nix pattern
{ pkgs, callPackage, fetchFromGitHub, python312, uv2nix, pyproject-nix, pyproject-build-systems }:

callPackage ../../reference/generic-uv2nix-proper.nix {
  pname = "mcp-nixos";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    rev = "v1.0.0";
    hash = "sha256-NwP+zM1VGLOzIm+mLZVK9/9ImFwuiWhRJ9QK3hGpQsY=";
  };
  inherit pkgs python312 uv2nix pyproject-nix pyproject-build-systems;
}
