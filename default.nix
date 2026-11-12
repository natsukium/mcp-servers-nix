{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) lib;
  # Packages that only build on Linux. They stay in the overlay (which cannot
  # branch on the platform without infinite recursion), but are left out here
  # so that `nix flake check` keeps evaluating on Darwin.
  linuxOnlyPackages = [
    "agent-workspace-linux"
    "computer-use-linux"
  ];
  packages = lib.filterAttrs (
    name: _: pkgs.stdenv.hostPlatform.isLinux || !lib.elem name linuxOnlyPackages
  ) (import ./pkgs { inherit pkgs; });
in
{
  lib = import ./lib;
  inherit packages;
}
// packages
