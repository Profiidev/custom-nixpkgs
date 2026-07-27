{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "google-vicinae-extension";

  src = sources.googleSearchRaycastExtension;
})
