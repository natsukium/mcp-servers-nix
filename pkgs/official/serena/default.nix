{
  lib,
  fetchFromGitHub,
  nodejs,
  pyright,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "serena";
  version = "0.1.4-unstable-2025-10-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "1461aff18c5010a711c286d0401fb86729088050";
    hash = "sha256-WffvPxyPPZh1JStofCvzwwUNRRfAGTW2Y4ApvnMQ0Vk=";
  };

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
    docstring-parser
    flask
    jinja2
    joblib
    mcp
    overrides
    pathspec
    psutil
    pydantic
    pyright
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
