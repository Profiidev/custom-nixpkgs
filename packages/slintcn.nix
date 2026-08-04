{
  rustPlatform,
  fetchCrate,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "slintcn";
  version = "0.35.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-kLjruuqzIMGYr/3vGh65UrGOhdHigetDLIwyqM83+J0=";
  };

  cargoHash = "sha256-kdFG0mhM1/2Fy2RHV18VvfrsACpKwu3w8m7ylLeZVtc=";

  meta = {
    description = "Slint component library";
    homepage = "https://zero-sq.github.io/slintcn";
    license = lib.licenses.mit;
  };
}
