{ fetchFromGitHub }:
rec {
  version = "2.4.0";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${version}";
    hash = "sha256-edwibnJdNuOAF31FbZQ/CVDxM5WyIxl0ycmebTkWroE=";
  };
  # Kept next to src so that nix-update, pointed at this file, updates it too.
  npmDepsHash = "sha256-t/Ugjb1nySxNNKcw9IGFAvuUwTBebmWPr1EgANY/DOk=";
}
