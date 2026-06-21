{
  rustPlatform,
  fetchCrate,
  lib,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri-driver";
  version = "2.0.6";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-fTCkEs4NLBW0khaHL4jpVNkrbQg22YPsRMjfJNqnCWA=";
  };

  cargoHash = "sha256-MThAcU+U8PyBGauh3dy7ZRvRX9INmOEeghIlQEGLAPs=";

  meta = {
    description = "Tauri driver";
    homepage = "https://github.com/tauri-apps/tauri";
    license = lib.licenses.mit;
  };
}
