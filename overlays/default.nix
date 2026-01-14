final: prev:
let
  packages = import ../pkgs { pkgs = final; };
in
builtins.removeAttrs packages [
  "mcp-grafana"
  "github-mcp-server"
  "clickup-mcp-server"
]
