{ fetchFromGitHub }:
rec {
  version = "2026.7.10";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = version;
    hash = "sha256-ORihWA8Xx7WAPo2+vRPpYNF9CGfc1sjmW+NfUKBGzxs=";
  };
}
