{ callPackage, fetchFromGitHub, python311 }:

callPackage ../../reference/generic-uv.nix {
  pname = "mcp-filesystem";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "timblaktu";
    repo = "mcp-filesystem-safurrier";
    rev = "uv"; # Using the UV branch
    hash = "sha256-3YQFi5BOCHEgOVH0QtfTu/BdzfMNdiRqwU4CgRWemXc=";
  };
  inherit python311;
}
