{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "spotify-player-vicinae-extension";

  src = sources.spotifyPlayerRaycastExtension;
})
