{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  glib,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "computer-use-linux";
  version = "0.7.48";

  src = fetchFromGitHub {
    owner = "agent-sh";
    repo = "computer-use-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4uIH7SuOlx5ZHsDoB1ct2z5X79fRlkcf/c9m/DseU0U=";
  };

  cargoHash = "sha256-c46Hob/yaSOuoL4M9tcqvvyaf82x6CeoxMN0NNylmJ4=";

  nativeBuildInputs = [
    makeWrapper
  ];

  # The suites drive the live AT-SPI bus, portals and compositor of the host.
  doCheck = false;

  # xkbcommon-dl opens libxkbcommon at run time to verify literal text
  # against the active keymap.
  #
  # gdbus probes the KWin and GNOME Shell window backends, and gsettings
  # enables the GNOME AT-SPI bridge (`setup`); both are desktop-agnostic,
  # so ship them, appended to PATH so a host glib wins.
  #
  # The compositor helpers (ydotool, wtype, xdotool, hyprctl, kscreen-doctor,
  # gnome-extensions, ...) are deliberately left to the host: which ones are
  # used depends on the running desktop, and `computer-use-linux doctor`
  # reports what is missing. The COSMIC helper and the indicator overlay are
  # found next to the main binary, so they only need to share $out/bin.
  postFixup = ''
    patchelf $out/bin/computer-use-linux --add-rpath ${lib.makeLibraryPath [ libxkbcommon ]}
    wrapProgram $out/bin/computer-use-linux \
      --suffix PATH : ${lib.makeBinPath [ glib ]}
  '';

  # The CLI has no --version flag (the version is only reported to MCP
  # clients in server_info), so smoke-test the argument parser instead.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/computer-use-linux --help | grep -q 'doctor'
    runHook postInstallCheck
  '';

  meta = {
    description = "Native Linux desktop control for AI agents over MCP and CLI (AT-SPI, Wayland/X11 input, screenshots)";
    homepage = "https://github.com/agent-sh/computer-use-linux";
    changelog = "https://github.com/agent-sh/computer-use-linux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [ ];
    mainProgram = "computer-use-linux";
    platforms = lib.platforms.linux;
  };
})
