{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "whois-vicinae-extension";

  src = sources.whoisRaycastExtension;
})
