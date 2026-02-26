{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "clipboard-history-cosmic-applet";
  version = "unstable-2025-10-17";

  src = fetchFromGitHub {
    owner = "ProfiiDev";
    repo = "clipboard-history";
    rev = "3c7e67ebc77daa02d7e7a8ffb2b131b95a3f1d83";
    hash = "sha256-zTqQUx6K/yKMgD0A4WybrniDHM4OHE2STCNtW+rYFBI=";
    #hash = lib.fakeHash;
  };

  cargoHash = "sha256-SRkvBsb86HmDjRB3rU2Ya6A8FJS59OSIoyor97MpT9M=";
  #cargoHash = lib.fakeHash;

  postPatch = ''
    substituteInPlace cosmic-applet/justfile --replace 'clipboard-history-cosmic-applet' 'ringboard-cosmic-applet'
  '';

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  env = {
    RUSTC_BOOTSTRAP = true;
  };

  cargoBuildFlags = [
    "--package"
    "clipboard-history-cosmic-applet"
  ];

  justFlags = [
    "--justfile"
    "cosmic-applet/justfile"
    "--working-directory"
    "cosmic-applet"
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "../target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/clipboard-history-cosmic-applet"
    "--set"
    "icon-svg-src"
    "resources/icons/clipboard.svg"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A COSMIC applet for ringboard";
    homepage = "https://github.com/ProfiiDev/clipboard-history";
    license = lib.licenses.gpl3Only;
    maintainers = [
    ];
    mainProgram = "clipboard-history-cosmic-applet";
  };
}
