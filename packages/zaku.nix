{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  copyDesktopItems,
  fontconfig,
  freetype,
  libxkbcommon,
  sqlite,
  vulkan-loader,
  zstd,
  stdenv,
  wayland,
  libx11,
  libxcb,
  libglvnd,
  nix-update-script,
}:

let
  # GPUI/blade dlopen these at runtime, so they never end up on the RPATH via
  # buildInputs; add them explicitly in postFixup.
  runtimeLibs = [
    vulkan-loader
    wayland
    libxkbcommon
    libxcb
    libx11
    libglvnd
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zaku";
  version = "26.0-beta.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "buildzaku";
    repo = "zaku";
    tag = finalAttrs.version;
    hash = "sha256-U5sR7uEnBqZhpHKLV8caYgi5ZrXrOq2LEdAubpy1XXM=";
  };

  cargoHash = "sha256-7qkv/p7rYniLJxXVV1OkBUBKDahRmpelN6CGztSm+4o=";

  # crates/metadata/build.rs shells out to `git rev-parse HEAD`; no .git or git
  # binary in the sandbox, so hardcode the version instead.
  postPatch = ''
    substituteInPlace crates/metadata/build.rs \
      --replace-fail 'let commit_sha = commit_sha();' \
                     'let commit_sha = String::from("${finalAttrs.version}");'
  '';

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    sqlite
    vulkan-loader
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libx11
    libxcb
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  desktopItems = [ "crates/zaku/resources/dev.zaku.Zaku.desktop" ];

  postInstall = ''
    install -Dm644 crates/zaku/resources/app-icon.png \
      $out/share/icons/hicolor/512x512/apps/zaku.png
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath "${lib.makeLibraryPath runtimeLibs}" $out/bin/zaku
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zaku is a native Rust, local-first, open-source API client engineered for speed and productivity";
    homepage = "https://github.com/buildzaku/zaku";
    license = lib.licenses.agpl3Only;
    mainProgram = "zaku";
    platforms = lib.platforms.linux;
  };
})
