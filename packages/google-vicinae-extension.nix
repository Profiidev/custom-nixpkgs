{
  mkVicinaeExtension,
  sources,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "google-vicinae-extension";

  src = sources.googleSearchRaycastExtension;
}).overrideAttrs
  (oldAttrs: {
    buildPhase = "npm run build -- -o=$out";
  })
