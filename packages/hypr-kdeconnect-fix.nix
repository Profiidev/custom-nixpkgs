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
  version = "0-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "9aa0b14d042d495bbb43809a860ec667eeb4b6ce";
    hash = "sha256-ZbXf6j9wzRgaaMHkaCq53DGrDsZsZo6PtIOBL3FIOm8=";
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
