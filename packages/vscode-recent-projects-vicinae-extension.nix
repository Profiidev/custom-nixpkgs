{
  mkVicinaeExtension,
  sqlite,
  sources,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "vscode-recent-projects-vicinae-extension";

  src = sources.vscodeRecentProjectsRaycastExtension;
}).overrideAttrs
  (old: {
    buildPhase = "npm run build -- -o=$out";
    patches = [
      ../patches/vscode-vicinae-extension.patch
    ];

    runtimeDependencies = [
      sqlite
    ];
  })
