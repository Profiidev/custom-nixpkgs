{
  mkVicinaeExtension,
  sqlite,
  sources,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "zed-recent-projects-vicinae-extension";

  src = sources.zedRecentProjectsRaycastExtension;
}).overrideAttrs
  (old: {
    buildPhase = "npm run build -- -o=$out";
    patches = [
      ../patches/zed-vicinae-extension.patch
    ];

    runtimeDependencies = [
      sqlite
    ];
  })
