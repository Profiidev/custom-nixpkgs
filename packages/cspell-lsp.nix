{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  ...
}:

buildNpmPackage rec {
  pname = "cspell-lsp";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "vlabo";
    repo = "cspell-lsp";
    rev = "v${version}";
    hash = "sha256-ZLZMVw0uvr4rQ9SKMVj1Sjoj+QeK2UL3RWsnzNRdPwI=";
  };

  nativeBuildInputs = [ bun ];

  npmDepsHash = "sha256-XYgtV3XMEriMjC06QfudL0fyoTY1PobnpUf4PQGOA2U=";

  meta = with lib; {
    description = "cspell-lsp";
    homepage = "https://github.com/vlabo/cspell-lsp";
    license = licenses.mit;
    maintainers = [ ];
  };
}
