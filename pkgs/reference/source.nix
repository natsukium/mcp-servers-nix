{ fetchFromGitHub }:
rec {
  version = "2025.7.1";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = version;
    hash = "sha256-Ujzr3F34550JA/hxKmFHXugX41duxcUVXU4nYmlMtDs=";
  };
}
