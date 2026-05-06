{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs-slim,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "context7-mcp";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "@upstash/context7-mcp@${finalAttrs.version}";
    hash = "sha256-FiOzc1jkx7XUBgMpfOIPBa8H44Th4pOuUQ0WQfjE5z4=";
  };

  pnpmWorkspaces = [ "@upstash/context7-mcp" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-b4qPRk6FaKo1IamUf2esAUnBwxfxWRD/LV7u4L/u6u0=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter @upstash/context7-mcp build

    runHook postBuild
  '';

  # Re-resolve with `--prod --filter` to drop devDependencies and unrelated
  # workspace packages (sdk, tools-ai-sdk, cli) from the runtime closure.
  installPhase = ''
    runHook preInstall

    rm -rf node_modules packages/*/node_modules
    pnpm install --prod --offline --frozen-lockfile --filter @upstash/context7-mcp

    mkdir -p $out/bin $out/lib/context7-mcp
    cp -r node_modules packages $out/lib/context7-mcp/

    makeBinaryWrapper ${nodejs-slim}/bin/node $out/bin/context7-mcp \
      --add-flags "$out/lib/context7-mcp/packages/mcp/dist/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "@upstash/context7-mcp@(.*)"
    ];
  };

  meta = {
    description = "Up-to-date code documentation for LLMs and AI code editors";
    homepage = "https://context7.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      rec {
        github = "vaporif";
        githubId = 3934971;
        name = github;
      }
    ];
    mainProgram = "context7-mcp";
  };
})
