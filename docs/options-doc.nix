{
  pkgs ?
    import
      (
        let
          lock = builtins.fromJSON (builtins.readFile ../flake.lock);
          nixpkgs = lock.nodes.nixpkgs.locked;
        in
        builtins.fetchTarball {
          url = "https://github.com/${nixpkgs.owner}/${nixpkgs.repo}/archive/${nixpkgs.rev}.tar.gz";
          sha256 = nixpkgs.narHash;
        }
      )
      {
        config = {
          allowUnfree = true;
          allowInsecurePredicate = _: true;
        };
      },
}:
let
  inherit (pkgs) lib;
  mcp-lib = import ../lib;
  # allowUnfree is needed because some module defaults reference unfree packages
  # (e.g., playwright.executable defaults to google-chrome on macOS)
  eval = mcp-lib.evalModule pkgs {
    _module.check = false;
  };

  rootPath = toString ./..;
  revision = "main";

  gitHubDeclaration = subpath: {
    url = "https://github.com/natsukium/mcp-servers-nix/blob/${revision}/${subpath}";
    name = "<mcp-servers-nix/${subpath}>";
  };

  optionsDoc = pkgs.nixosOptionsDoc {
    options = builtins.removeAttrs eval.options [ "_module" ];
    documentType = "none";
    warningsAreErrors = false;
    transformOptions =
      opt:
      opt
      // {
        declarations = map (
          decl:
          let
            declStr = toString decl;
          in
          if lib.hasPrefix rootPath declStr then
            gitHubDeclaration (lib.removePrefix "/" (lib.removePrefix rootPath declStr))
          else
            decl
        ) opt.declarations;
      };
  };
in
{
  inherit (optionsDoc) optionsCommonMark;

  check = pkgs.runCommand "check-module-options-doc" { } ''
    if ! ${pkgs.diffutils}/bin/diff -q ${optionsDoc.optionsCommonMark} ${../docs/module-options.md}; then
      echo "docs/module-options.md is out of date."
      echo "Run: nix build -f docs/options-doc.nix optionsCommonMark && install -m 644 result docs/module-options.md"
      exit 1
    fi
    echo "docs/module-options.md is up to date" > $out
  '';
}
