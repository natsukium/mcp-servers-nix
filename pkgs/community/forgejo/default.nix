{
  lib,
  buildGoModule,
  fetchFromGitea,
  nix-update-script,
}:

buildGoModule rec {
  pname = "forgejo-mcp";
  version = "2.4.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "goern";
    repo = "forgejo-mcp";
    rev = "v${version}";
    hash = "sha256-2MSijIu//kLYB7xykixZR5KOO77/R5IYoozrbfMKmQ8=";
  };

  vendorHash = "sha256-tOTRbc735TrIZ7fL9EywKLLlePKWMMCeuhbQJGHUuk4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This Model Context Protocol (MCP) server provides tools and resources for interacting with the Forgejo (specifically Codeberg.org) REST API";
    homepage = "https://codeberg.org/goern/forgejo-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "forgejo-mcp";
  };
}
