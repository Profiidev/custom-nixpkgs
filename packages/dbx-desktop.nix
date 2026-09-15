{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  pkg-config,
  perl,
  wrapGAppsHook4,
  openssl,
  webkitgtk_4_1,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  libayatana-appindicator,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbx-desktop";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "t8y2";
    repo = "dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTiB85NNkztY/Yc2urAZb4Jczuex+LdPFGzyulc3Fcw=";
  };

  cargoHash = "sha256-H7p1mOMoz1gUH9IeR3Aea0QJhoC2sNlEmepERXcicx8=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-8hA97KK+5J9w1YZpMEQuzFZnsXMuIQ0oSYySc3AVGcg=";
  };

  # updater artifacts need TAURI_SIGNING_PRIVATE_KEY
  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    perl
    cargo-tauri.hook
    glib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    webkitgtk_4_1
    openssl
    glib-networking
    gsettings-desktop-schemas
    libayatana-appindicator
  ];

  doCheck = false;
  auditable = false;

  meta = {
    description = "DBX desktop — open-source database management tool (Tauri 2)";
    longDescription = ''
      DBX is a lightweight (~15 MB) database management tool supporting 90+
      databases. Built with Tauri 2, Vue 3, and Rust. No Java, no Chromium.
    '';
    license = lib.licenses.asl20;
    homepage = "https://github.com/t8y2/dbx";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "dbx";
    desktopFile = "${placeholder "out"}/share/applications/DBX.desktop";
  };
})
