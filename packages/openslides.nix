{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  bun2nix,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  wrapGAppsHook4,
  cacert,
  cargo-tauri,
  glib,
  gsettings-desktop-schemas,
}:

rustPlatform.buildRustPackage rec {
  pname = "openslides";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "codewiththiha";
    repo = "OpenSlides";
    tag = "v${version}";
    hash = "sha256-zbDuOE+vxUE6XZniuoaMVYmaB2RW2QRX3EQr/a5k1GI=";
  };

  cargoLock = {
    lockFile = "${src}/src-tauri/Cargo.lock";
  };
  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs = [
    cacert
    cargo-tauri.hook
    pkg-config
    bun2nix.hook
    pkg-config
    glib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    gsettings-desktop-schemas
  ];

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./openslides/bun.nix;
  };

  doCheck = false;

  meta = {
    description = "Offline-first code presentation desktop app";
    homepage = "https://github.com/codewiththiha/OpenSlides";
    mainProgram = "openslides";
    platforms = lib.platforms.linux;
  };
}
