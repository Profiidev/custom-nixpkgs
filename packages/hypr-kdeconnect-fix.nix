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
  version = "0-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "d1c1216dd56aefc8fa096abe214e2c68a8e1b3c0";
    hash = "sha256-7z92WekZYESyo/5keLlT2DmpuE6uNaYShKu0ROn7/3E=";
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
