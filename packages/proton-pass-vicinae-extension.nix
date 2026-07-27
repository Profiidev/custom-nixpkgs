{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "proton-pass-vicinae-extension";

  src = sources.protonPassRaycastExtension;
})
