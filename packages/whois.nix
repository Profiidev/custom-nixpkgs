{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "whois";

  src = sources.whoisRaycastExtension;
})
