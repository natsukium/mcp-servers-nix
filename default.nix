{
  pkgs ? import <nixpkgs> { },
  uv2nix ? null,
  pyproject-nix ? null,
}:
let
  packages = import ./pkgs { inherit pkgs uv2nix pyproject-nix; };
in
{
  lib = import ./lib;
  inherit packages;
}
// packages
