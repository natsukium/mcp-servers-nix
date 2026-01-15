{ fetchFromGitHub }:
rec {
  version = "2025.12.18";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = version;
    hash = "sha256-Km0MjjZhhijynYyju3tMJwsplrpNUr4cJ95TxqgrrR8=";
  };
}
