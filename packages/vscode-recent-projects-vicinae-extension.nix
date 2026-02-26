{
  mkVicinaeExtension,
  fetchFromGitHub,
  sqlite,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "vscode-recent-projects-vicinae-extension";

  src = "${
    fetchFromGitHub {
      owner = "raycast";
      repo = "extensions";
      rev = "3745b33cbc5ae69d99eb0ded423eab1b494272a0";
      hash = "sha256-/Wi5zSqFXiWFmuQu1dYkx1B85XXcI+dpsjqMirUKt9g=";

      sparseCheckout = [
        "extensions/visual-studio-code-recent-projects"
      ];
    }
  }/extensions/visual-studio-code-recent-projects";
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
