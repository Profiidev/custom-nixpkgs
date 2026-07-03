{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "unix-timestamp";

  src = sources.unixTimestampRaycastExtension;
})
