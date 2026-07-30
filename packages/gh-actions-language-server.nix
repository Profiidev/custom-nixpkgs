{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "gh-actions-language-server";
  version = "0.3.60";
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  src = "${
    fetchFromGitHub {
      owner = "actions";
      repo = "languageservices";
      tag = "release-v${finalAttrs.version}";
      hash = "sha256-YXVgYGa7LFEfDuIAIeEwYJD+45l+ytuWSZ+yPlWMJdg=";
    }
  }/languageserver";

  patches = [
    ../patches/gh-actions-language-server.patch
  ];

  postPatch = ''
    cp ${./gh-actions-language-server/package-lock.json} package-lock.json
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-yI10QvIQo6sRTUncc3DVQQAdqIpQN7Dg/B0kvZW5Awk=";
  npmDoInstall = false;

  installPhase = ''
    mkdir -p $out/share/gh-actions-language-server
    cp dist/cli.bundle.cjs $out/share/gh-actions-language-server/

    makeWrapper ${lib.getExe nodejs} $out/bin/gh-actions-language-server \
      --add-flags $out/share/gh-actions-language-server/cli.bundle.cjs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language services for GitHub Actions workflows and expressions";
    homepage = "https://github.com/actions/languageservices";
    license = lib.licenses.mit;
    mainProgram = "gh-actions-language-server";
    platforms = lib.platforms.all;
  };
})
