{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, pyproject-nix, uv2nix }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      lib = import ./lib;

      packages = forAllSystems (
        system: (import ./. { pkgs = import nixpkgs { inherit system; }; }).packages
      );

      overlays.default = import ./overlays;

      checks = lib.foldr (x: acc: lib.recursiveUpdate x acc) { } [
        (forAllSystems (system: import ./tests { pkgs = import nixpkgs { inherit system; }; }))
        (forAllSystems (
          system:
          import ./examples {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        ))
        self.packages
      ];
    };
}
