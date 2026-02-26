{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "gui-scale-applet";
  version = "2.0.0-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "4e4074738626fafeee26d9cb38c8587899242f0a";
    hash = "sha256-t+8IrQL1zq9gKlVwwgBL2Qkh2LInDhqP9C/5OvRYjNw=";
  };

  cargoHash = "sha256-WofBwEM85rvwxHVM6CMC08INLFV2UNdjti3bE0SLnj4=";

  postPatch = ''
    sed -i 's/sudo //g' justfile
  '';

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A COSMIC applet for managing tailscale VPN connections";
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    license = lib.licenses.gpl3Only;
    maintainers = [
    ];
    mainProgram = "gui-scale-applet";
  };
}
