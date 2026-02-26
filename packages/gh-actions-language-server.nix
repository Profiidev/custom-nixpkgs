{
  lib,
  mkBunDerivation,
  fetchFromGitHub,
  ...
}:

let
  bunLock = ./gh-actions-language-server/bun.lock;
in
mkBunDerivation {
  pname = "gh-actions-language-server";
  version = "unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "lttb";
    repo = "gh-actions-language-server";
    rev = "0287d3081d7b74fef88824ca3bd6e9a44323a54d";
    hash = "sha256-ZWO5G33FXGO57Zca5B5i8zaE8eFbBCrEtmwwR3m1Px4=";
  };

  postPatch = ''
    cp ${bunLock} ./bun.lock
    rm ./.bun-version
  '';

  index = "index.js";
  bunNix = ./gh-actions-language-server/bun.nix;

  meta = with lib; {
    description = "GH actions lsp";
    homepage = "https://github.com/lttb/gh-actions-language-server";
    license = licenses.mit;
    maintainers = [ ];
  };
}
