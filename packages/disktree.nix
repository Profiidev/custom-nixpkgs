{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fontconfig,
  libxkbcommon,
  wayland,
  vulkan-loader,
  libxcb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktree";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "disktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b7VP3VgOS+zUTR2bhOh6JNcN5mIIeHL/fe3u/eHC+X4=";
  };

  cargoHash = "sha256-k+iLvOS+6o5oC+JcG9BJ3UUAzZAQpcpNelKCXsDx0Fw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  doCheck = false;

  buildInputs = [
    fontconfig
    libxkbcommon
    libxcb
  ];

  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        wayland
        vulkan-loader
      ]
    } $out/bin/disktree
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A treemap for finding and removing what fills your disk, for Omarchy. Rust + GPUI";
    homepage = "https://github.com/tobi/disktree";
    changelog = "https://github.com/tobi/disktree/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ profidev ];
    mainProgram = "disktree";
  };
})
