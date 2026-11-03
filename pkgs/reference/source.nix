{ fetchFromGitHub }:
rec {
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${version}";
    hash = "sha256-9dXpm2MRye4a3lEt2oYP/SO4tJmZ94HWL5mf/zlC5z4=";
  };
  # Kept next to src so that nix-update, pointed at this file, updates it too.
  npmDepsHash = "sha256-wnrR1mv9p8xBzArhSrOOM0l87PgBSUl2o6Th1kaAst0=";
}
