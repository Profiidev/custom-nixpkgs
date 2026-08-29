{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  sources,
}:

let
  # nixpkgs' openai-agents 0.18.1 omits websockets, now a required runtime dep.
  openai-agents = python3Packages.openai-agents.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ [ python3Packages.websockets ];
  });

  # Not packaged in nixpkgs; pure-python wheels pulled straight from PyPI.
  caido-server-auth = python3Packages.buildPythonPackage {
    pname = "caido-server-auth";
    version = "0.1.2";
    format = "wheel";
    src = sources.caidoServerAuthWheel;
    dependencies = with python3Packages; [
      gql
      aiohttp
      websockets
    ];
  };

  caido-sdk-client = python3Packages.buildPythonPackage {
    pname = "caido-sdk-client";
    version = "0.2.0";
    format = "wheel";
    src = sources.caidoSdkClientWheel;
    dependencies = with python3Packages; [
      caido-server-auth
      gql
      aiohttp
      websockets
      pydantic
    ];
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "strix";
  version = "1.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "usestrix";
    repo = "strix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2aYpc7ZMYuSso3ktDSF7yIJXLJpGDbaVhRfxiFE4Gg=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  # Upstream pins versions nixpkgs doesn't match exactly; the shipped ones work.
  pythonRelaxDeps = [
    "openai-agents"
    "pydantic-settings"
  ];

  dependencies = with python3Packages; [
    caido-sdk-client
    cvss
    docker
    litellm
    openai-agents
    pydantic
    pydantic-settings
    requests
    rich
    textual
  ];

  pythonImportsCheck = [
    "strix"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source AI penetration testing tool to find and fix your app’s vulnerabilities";
    homepage = "https://github.com/usestrix/strix";
    changelog = "https://github.com/usestrix/strix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "strix";
  };
})
