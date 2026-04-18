{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nodejs,
}:

let
  version = "0.20.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${version}.tgz";
    sha256 = "1vz22g7cddwnd594la3i6v23hx90dbm2khabx7ncqsmnb9v5nzv1";
  };
in
stdenv.mkDerivation {
  pname = "chrome-devtools-mcp";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    tar -xzf $src

    mkdir -p $out/lib/chrome-devtools-mcp
    cp -r package/* $out/lib/chrome-devtools-mcp/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/chrome-devtools-mcp \
      --add-flags "$out/lib/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js" \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set NODE_PATH "$out/lib/chrome-devtools-mcp/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "Chrome DevTools MCP server for AI coding agents";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "chrome-devtools-mcp";
  };
}