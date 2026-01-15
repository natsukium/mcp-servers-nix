{
  lib,
  fetchFromGitHub,
  fortls,
  nodejs,
  pyright,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "serena";
  version = "0.1.4-unstable-2026-01-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "dd3c97b81fd708dfeb1ac39ffc75cf6ab7caa679";
    hash = "sha256-n39CSIsVLIAmJoPTLPM+D6vAAqilHLp01KqZMOxP0q8=";
  };

  # I'm not sure why upstream uses blib2to3, such an ancient and unmaintained package
  postPatch = ''
    substituteInPlace test/conftest.py \
      --replace-fail "from blib2to3.pgen2.parse import contextmanager" "from contextlib import contextmanager"
    substituteInPlace src/solidlsp/language_servers/pyright_server.py \
      --replace-fail "python -m pyright.langserver --stdio" "${lib.getExe' pyright "pyright-langserver"} --stdio"
  '';

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # pyright is not available as a Python package in nixpkgs
    "pyright"
    # dotenv is a legacy package, likely added as a dependency by mistake
    # python-dotenv can be used as a replacement and is not actually used in the code
    "dotenv"
  ];

  dependencies = with python3Packages; [
    anthropic
    beautifulsoup4
    docstring-parser
    flask
    fortls
    jinja2
    joblib
    mcp
    overrides
    pathspec
    psutil
    pydantic
    python-dotenv
    pyyaml
    requests
    ruamel-yaml
    sensai-utils
    tiktoken
    tqdm
    types-pyyaml
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      nodejs
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
    "test_symbol_editing.py"

    # Tests fail in upstream CI due to LSP server initialization issues
    "test_create_with_index_flag"
    "test_index_auto_creates_project_with_files"
    "test_index_is_equivalent_to_create_with_index"
    "test_index_with_explicit_language"
  ];

  pytestFlags = [ "test/serena" ];

  meta = {
    description = "Powerful coding agent toolkit providing semantic retrieval and editing capabilities";
    homepage = "https://github.com/oraios/serena";
    changelog = "https://github.com/oraios/serena/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "serena";
  };
}
