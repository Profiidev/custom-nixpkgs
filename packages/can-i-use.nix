{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "can-i-use";

  src = sources.canIUseRaycastExtension;
})
