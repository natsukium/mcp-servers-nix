{
  darwin,
  lib,
  fetchFromGitHub,
  fortls,
  nodejs,
  pyright,
  python3Packages,
  stdenv,
  ty,
  writableTmpDirAsHomeHook,
}:

let
  # pywebview requires pyobjc-framework-UniformTypeIdentifiers on Darwin to
  # populate file dialog content types, but nixpkgs does not yet ship it.
  # Build it here from the same pyobjc source already used by the other
  # pyobjc-framework-* packages in nixpkgs.
  pyobjc-framework-uniformtypeidentifiers = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-uniformtypeidentifiers";
    pyproject = true;

    inherit (python3Packages.pyobjc-core) version src patches;

    sourceRoot = "${python3Packages.pyobjc-core.src.name}/pyobjc-framework-UniformTypeIdentifiers";

    build-system = [ python3Packages.setuptools ];

    buildInputs = [ darwin.libffi ];
    nativeBuildInputs = [ darwin.DarwinTools ];

    postPatch = ''
      substituteInPlace pyobjc_setup.py \
        --replace-fail "-buildversion" "-buildVersion" \
        --replace-fail "-productversion" "-productVersion" \
        --replace-fail "/usr/bin/sw_vers" "sw_vers" \
        --replace-fail "/usr/bin/xcrun" "xcrun"
    '';

    dependencies = with python3Packages; [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];

    env.NIX_CFLAGS_COMPILE = toString [
      "-I${darwin.libffi.dev}/include"
      "-Wno-error=unused-command-line-argument"
    ];

    pythonImportsCheck = [ "UniformTypeIdentifiers" ];

    meta = {
      description = "PyObjC wrappers for the UniformTypeIdentifiers framework on macOS";
      homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-framework-UniformTypeIdentifiers";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  pywebview = python3Packages.pywebview.overridePythonAttrs (
    old:
    lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      dependencies = (old.dependencies or [ ]) ++ [ pyobjc-framework-uniformtypeidentifiers ];
    }
  );
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "serena";
  version = "1.5.3-unstable-2026-07-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "9bbbfea8d62d130d06037cc0b283291bd20e79c3";
    hash = "sha256-VyouKfOJl4FwSTcW1hDLsq5/BX6+1BKUL+LG+wnKWYE=";
  };

  # Serena resolves its bundled language servers (pyright, ty, fortls) on demand
  # via uvx, which requires network access. Launch them from PATH instead; the
  # nixpkgs-provided binaries are wired in through makeWrapperArgs below.
  patches = [ ./launch-language-servers-from-path.patch ];

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # pyright is not available as a Python package in nixpkgs
    "pyright"
    # dotenv is a legacy package, likely added as a dependency by mistake
    # python-dotenv can be used as a replacement and is not actually used in the code
    "dotenv"
  ];

  dependencies =
    (with python3Packages; [
      anthropic
      beautifulsoup4
      cryptography
      docstring-parser
      flask
      fortls
      jinja2
      joblib
      lsprotocol
      mcp
      oslex
      overrides
      pathspec
      psutil
      pydantic
      pygls
      pystray
      python-dotenv
      pyyaml
      requests
      ruamel-yaml
      sensai-utils
      tiktoken
      tqdm
      types-pyyaml
    ])
    ++ [
      pywebview
    ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      nodejs
      pyright
      ty
    ])
  ];

  pythonImportsCheck = [ "serena" ];

  nativeCheckInputs = with python3Packages; [
    pytest-xdist
    pytestCheckHook
    syrupy
    tkinter
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires various language runtimes and language servers
    "test_serena_agent.py"
    "test_symbol.py"
    "test_symbol_editing.py"

    # Tests fail in upstream CI due to LSP server initialization issues
    "test_create_with_index_flag"
    "test_index_auto_creates_project_with_files"
    "test_index_is_equivalent_to_create_with_index"
    "test_index_with_explicit_language"

    # Flaky tests due to YAML config parsing issues in sandbox
    "test_cli_project_commands.py"
  ];

  pytestFlags = [ "test/serena" ];

  meta = {
    description = "Powerful coding agent toolkit providing semantic retrieval and editing capabilities";
    homepage = "https://github.com/oraios/serena";
    changelog = "https://github.com/oraios/serena/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "serena";
  };
})
