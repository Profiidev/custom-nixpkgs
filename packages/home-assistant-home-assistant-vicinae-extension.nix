{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "home-assistant-vicinae-extension";

  src = sources.homeAssistantRaycastExtension;
})
