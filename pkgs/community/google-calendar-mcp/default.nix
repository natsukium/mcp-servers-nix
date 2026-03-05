{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "google-calendar-mcp";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "nspady";
    repo = "google-calendar-mcp";
    rev = "v${version}";
    hash = "sha256-kfLJKeCwZxEnn6+pRIFNSp77b3N44dQKF6qVrDwdFyg=";
  };

  npmDepsHash = "sha256-ejXTesfoTHzNxbS3Ay/PlEye1KvNw+/4h+0hBObtO8E=";

  meta = {
    description = "MCP integration for Google Calendar to manage events";
    homepage = "https://github.com/nspady/google-calendar-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antono ];
    mainProgram = "google-calendar-mcp";
  };
}
