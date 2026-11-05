{ fetchFromGitHub }:
rec {
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${version}";
    hash = "sha256-L6t0QuJshn207uc3+n+IoDp7vPuY2YLcu6ku1rEgzHk=";
  };
  # Kept next to src so that nix-update, pointed at this file, updates it too.
  npmDepsHash = "sha256-fBa3SEyrXM0R63ph6nK3HNI8xIK7km4Hg0LIBOz1D40=";
}
