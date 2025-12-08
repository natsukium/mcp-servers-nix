{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
  versionCheckHook,
}:

let
  version = "0.11.0";
in
stdenv.mkDerivation {
  pname = "chrome-devtools-mcp";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${version}.tgz";
    hash = "sha256-Gc+MqwV5HfkZLp2LHbSE1T2nqxnlqzG6Ls7NAORCCpE=";
  };

  nativeBuildInputs = [ nodejs makeWrapper ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    mkdir -p $out/lib/node_modules/chrome-devtools-mcp
    cp -r package/* $out/lib/node_modules/chrome-devtools-mcp/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/chrome-devtools-mcp \
      --add-flags "$out/lib/node_modules/chrome-devtools-mcp/build/src/index.js"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Chrome DevTools MCP server for AI coding agents";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    changelog = "https://github.com/ChromeDevTools/chrome-devtools-mcp/releases/tag/chrome-devtools-mcp-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "chrome-devtools-mcp";
  };
}
