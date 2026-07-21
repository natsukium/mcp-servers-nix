{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nodejs_24,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "chrome-devtools-mcp";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ChromeDevTools";
    repo = "chrome-devtools-mcp";
    tag = "chrome-devtools-mcp-v${finalAttrs.version}";
    hash = "sha256-qDji1ZA46H3+jEZ5SL7ga/pyRhJ9SAdBWYH1jKC/TVg=";
  };

  npmDepsHash = "sha256-t9PwLvjcUaGFBZpW504+V96TbEVukOp3skomtTFs8cA=";

  # Upstream runs its TypeScript build scripts directly with `node`, which
  # needs a Node with native type stripping.
  nodejs = nodejs_24;

  nativeBuildInputs = [ makeWrapper ];

  # puppeteer is a build-time dependency that upstream bundles into the
  # server; its postinstall would otherwise download a Chrome binary the Nix
  # sandbox cannot fetch. No browser is shipped: point the server at one at
  # runtime (the module's `executable` option does this via --executable-path).
  env.PUPPETEER_SKIP_DOWNLOAD = "true";

  # buildNpmPackage installs with `--ignore-scripts`, so the root `prepare`
  # script does not run automatically. It patches a conflicting global type
  # declaration in a dependency that otherwise breaks the `tsc` build.
  preBuild = ''
    npm run prepare
  '';

  # `bundle` runs tsc + rollup to produce the self-contained build/ output
  # with all runtime dependencies vendored into build/src/third_party.
  npmBuildScript = "bundle";

  # Opt out of upstream's telemetry by default: usage statistics sent to
  # Google and performance-trace URLs sent to the CrUX API. Both stay
  # overridable (yargs is last-wins), e.g. `--usage-statistics` re-enables it.
  postInstall = ''
    wrapProgram $out/bin/chrome-devtools-mcp \
      --add-flags "--no-usage-statistics --no-performance-crux"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Chrome DevTools MCP server for debugging web pages in a live Chrome browser";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    changelog = "https://github.com/ChromeDevTools/chrome-devtools-mcp/releases/tag/chrome-devtools-mcp-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aldoborrero ];
    mainProgram = "chrome-devtools-mcp";
  };
})
