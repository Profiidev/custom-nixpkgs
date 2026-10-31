{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  libxkbcommon,
  wayland,
  libei,
  qt6,
}:

stdenv.mkDerivation {
  pname = "hypr-kdeconnect-fix";
  version = "0-unstable-2026-10-16";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "809c1ea83ca71f94df929ccea04043f0c47c0c32";
    hash = "sha256-B48HclHpqfHjKbLDBkv8wUPJJWzf7gBAz5o/6YWUk3g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libei
    libxkbcommon
    qt6.qtbase
    wayland
  ];
}
