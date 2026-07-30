{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "languageservices";
  version = "0.3.60";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "actions";
    repo = "languageservices";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-YXVgYGa7LFEfDuIAIeEwYJD+45l+ytuWSZ+yPlWMJdg=";
  };

  dontNpmBuild = true;
  npmDepsHash = "sha256-uJR7EA8JZx6qKnn7DqValPbgJd3eVvT2uHqa+k49yl4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language services for GitHub Actions workflows and expressions";
    homepage = "https://github.com/actions/languageservices";
    license = lib.licenses.mit;
    mainProgram = "actions-languageserver";
    platforms = lib.platforms.all;
  };
})
