{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
  openssl,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-ollama";
  version = "unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-ollama";
    rev = "227df9d4b3d505d23ec5a3d3eef1197c24c96fb0";
    hash = "sha256-lnQFFLbvc4O5zhQHDfE7Yb7jXhc39rvfYrw6ChJhxog=";
  };

  cargoHash = "sha256-SZst8AYvgdOFt2qpWSSv5f6B6XwmGtnZc3eKi6PkO9Y=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A COSMIC applet for Ollama AI integration";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-ollama";
    license = lib.licenses.gpl3Only;
    maintainers = [
    ];
    mainProgram = "cosmic-ext-applet-ollama";
  };
}
