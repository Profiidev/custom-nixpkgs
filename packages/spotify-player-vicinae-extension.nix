{
  mkVicinaeExtension,
  sources,
  ...
}:

(mkVicinaeExtension {
  version = "0.1.0";
  pname = "spotify-player-vicinae-extension";

  src = sources.spotifyPlayerRaycastExtension;
}).overrideAttrs
  (oldAttrs: {
    buildPhase = "npm run build -- -o=$out";
  })
