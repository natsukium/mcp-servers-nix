{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "azure-mcp-server";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mcp";
    tag = "Azure.Mcp.Server-${version}";
    hash = "sha256-NTShVf783nUnP3H1WqCZkMul5MSDSpiwVZAfnTXxkFI=";
  };

  projectFile = "servers/Azure.Mcp.Server/src/Azure.Mcp.Server.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  executables = [ "azmcp" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Azure MCP Server - Model Context Protocol implementation for Azure";
    homepage = "https://github.com/microsoft/mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "azmcp";
  };
}
