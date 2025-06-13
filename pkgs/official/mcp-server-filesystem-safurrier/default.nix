{ callPackage, fetchFromGitHub }:

callPackage ../../reference/generic-uv.nix {
  pname = "mcp-filesystem";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "timblaktu";
    repo = "mcp-filesystem-safurrier";
    rev = "uv"; # Using the UV branch
    hash = "sha256-0xwrkqaq20jfq5m28xhdyg6mvw5vsgbl5x2i74h7222fj25hb16x";
  };
}
