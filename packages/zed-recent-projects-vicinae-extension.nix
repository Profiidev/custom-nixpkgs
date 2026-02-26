{
  mkVicinaeExtension,
  fetchFromGitHub,
  sqlite,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "zed-recent-projects-vicinae-extension";

  src = "${
    fetchFromGitHub {
      owner = "raycast";
      repo = "extensions";
      rev = "5f940aa695abefba647e6f0e5d8adc3dce80642d";
      hash = "sha256-ZTwj++zrsdcGwGUNLQvlkmpG60zqrw+l00+XigU3COY=";

      sparseCheckout = [
        "extensions/zed-recent-projects"
      ];
    }
  }/extensions/zed-recent-projects";
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
