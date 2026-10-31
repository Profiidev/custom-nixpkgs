{
  rustPlatform,
  fetchCrate,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri-driver";
  version = "2.1.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-Ttik3t/IUnze3SHcpH9zPS1UwW9B/V70Wvel+eBHhOE=";
  };

  cargoHash = "sha256-x7cz2KLNLJRlPqahV/BwyYJcncfUyhIp6/gORhvudZI=";

  meta = {
    description = "Tauri driver";
    homepage = "https://github.com/tauri-apps/tauri";
    license = lib.licenses.mit;
  };
}
