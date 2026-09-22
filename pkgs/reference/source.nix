{ fetchFromGitHub }:
rec {
  version = "2026.8.31";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = version;
    hash = "sha256-6woyDFfHbv8oZDN7lXrNnjZM8viYsBfMe/NtcHdDZcw=";
  };
}
