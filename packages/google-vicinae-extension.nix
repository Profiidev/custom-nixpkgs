{
  mkVicinaeExtension,
  fetchFromGitHub,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "google-vicinae-extension";

  src = "${
    fetchFromGitHub {
      owner = "raycast";
      repo = "extensions";
      rev = "3745b33cbc5ae69d99eb0ded423eab1b494272a0";
      hash = "sha256-JQwPpzeHKalstRNtTlX00/Sv2VR/7DIRtOQcNCgSaL8=";

      sparseCheckout = [
        "extensions/google-search"
      ];
    }
  }/extensions/google-search";

}).overrideAttrs
  (oldAttrs: {
    buildPhase = "npm run build -- -o=$out";
  })
