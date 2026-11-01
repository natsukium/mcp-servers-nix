{ fetchFromGitHub }:
rec {
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "v${version}";
    hash = "sha256-9dXpm2MRye4a3lEt2oYP/SO4tJmZ94HWL5mf/zlC5z4=";
  };
}
