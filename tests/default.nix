{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) lib;
  dir = builtins.readDir ./.;
  nixFiles = builtins.filter (file: (lib.hasSuffix ".nix" file) && (file != "default.nix")) (
    builtins.attrNames dir
  );
  testDirs = builtins.filter (name: dir.${name} == "directory") (builtins.attrNames dir);
in
lib.mergeAttrsList (
  map (test: import (./. + "/${test}") { inherit pkgs; }) (nixFiles ++ testDirs)
)
