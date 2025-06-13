{
  pkgs ? import <nixpkgs> { },
  uv2nix ? null,
  pyproject-nix ? null,
  pyproject-build-systems ? null,
}:
let
  packages = import ./pkgs { inherit pkgs uv2nix pyproject-nix pyproject-build-systems; };
in
{
  lib = import ./lib;
  inherit packages;
}
// packages
