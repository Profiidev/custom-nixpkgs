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

  # Upstream's committed package-lock.json was generated with `--omit=dev`,
  # which strips `resolved`/`integrity` from most packages (not just dev
  # ones) and breaks fixed-output fetching. Vendor a fully resolved lockfile
  # instead (regenerated with `npm install --package-lock-only`).
  postPatch = ''
    cp ${./gh-actions-language-server/package-lock.json} package-lock.json
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-30tAOGfn6suO8xKSF1Up9pv2qLnZ12aXV3nHE8WLrPs=";

  # This is an npm workspaces monorepo; only the languageserver package (and
  # its runtime deps) should end up in $out.
  npmWorkspace = "languageserver";

  # Each workspace's `build` script only compiles that workspace, and there
  # are no TS project references tying them together, so build in dependency
  # order by hand instead of relying on npmBuildHook's single `npm run build`.
  buildPhase = ''
    runHook preBuild
    for ws in expressions workflow-parser languageservice languageserver; do
      npm run build --workspace=$ws
    done
    runHook postBuild
  '';

  # `npm prune --workspace=X` doesn't strip root-level devDependencies
  # (lerna + its nx dependency, ~65MB of native binaries), only per-workspace
  # ones. Prune unscoped ourselves before npmInstallHook copies node_modules;
  # it still keeps everything the other 3 workspaces need transitively.
  dontNpmPrune = true;
  preInstall = ''
    npm prune --omit=dev --no-save
  '';

  # npmInstallHook copies the root node_modules as-is, which leaves the
  # workspace packages (@actions/expressions, @actions/languageserver, etc.)
  # as symlinks back into the build tree, which no longer exists in $out.
  # Replace them with real copies of the built workspace directories.
  postInstall = ''
    pkgNodeModules="$out/lib/node_modules/actions-languageservices/node_modules/@actions"
    for dep in expressions workflow-parser languageservice languageserver; do
      link="$pkgNodeModules/$dep"
      rm -rf "$link"
      cp -r "$dep" "$link"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language services for GitHub Actions workflows and expressions";
    homepage = "https://github.com/actions/languageservices";
    license = lib.licenses.mit;
    mainProgram = "actions-languageserver";
    platforms = lib.platforms.all;
  };
})
