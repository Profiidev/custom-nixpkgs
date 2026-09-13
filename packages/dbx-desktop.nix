{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  removeReferencesTo,
  cargo-tauri,
  nodejs_22,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  pkg-config,
  perl,
  jq,
  imagemagick,
  desktop-file-utils,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  openssl,
  webkitgtk_4_1,
  gtk3,
  libappindicator-gtk3,
  libayatana-appindicator,
  librsvg,
  glib,
  glib-networking,
  dbus,
  at-spi2-atk,
  atkmm,
  cairo,
  gdk-pixbuf,
  harfbuzz,
  pango,
  xdotool,
  libx11,
  libxext,
  libxfixes,
}:

let
  linuxTauriDeps = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    gtk3
    libappindicator-gtk3
    libayatana-appindicator # provides libayatana-appindicator3.so.1 (dlopen'd at runtime)
    librsvg
    openssl
    glib
    glib-networking
    dbus
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    harfbuzz
    pango
    xdotool
    libx11
    libxext
    libxfixes
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbx-desktop";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "t8y2";
    repo = "dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTiB85NNkztY/Yc2urAZb4Jczuex+LdPFGzyulc3Fcw=";
  };

  # Keys are "<crate>-<version>" as they appear in Cargo.lock; importCargoLock
  # resolves each to its git rev, so one crate per repository is enough.
  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = {
      "libsqlite3-hotbundle-1.510300.0" = "sha256-X/DWDF+myQOArYz7131v4y3z6pLO1fuJ202qTGhh78I=";
      "mysql_common-0.38.0" = "sha256-fw1rDLNh0BByLHjS8Cgc7KQxdj3N51HVMHXvRyETsas=";
      "mysql_async-0.37.0" = "sha256-zIMZitF9fU6wkeuGAv4LJv80bCWbvmUkgQ1/G5MjDv8=";
      "tokio-postgres-0.7.18" = "sha256-ybf+2siiLokb2iylFEhmLAFCFmbjSKF+zNdH93LggkM=";
    };
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-8hA97KK+5J9w1YZpMEQuzFZnsXMuIQ0oSYySc3AVGcg=";
  };

  desktopItem = makeDesktopItem {
    name = "dbx";
    type = "Application";
    exec = "dbx %u";
    icon = "dbx";
    desktopName = "DBX";
    genericName = "Database Management Tool";
    comment = "Open-source database management tool for 90+ databases";
    categories = [
      "Development"
      "Database"
    ];
    keywords = [
      "database"
      "sql"
      "client"
      "mysql"
      "postgresql"
      "mongodb"
      "redis"
    ];
    startupWMClass = "DBX";
    terminal = false;
    mimeTypes = [
      "application/sql"
      "x-scheme-handler/dbx"
    ];
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm
    pnpmConfigHook
    pkg-config
    perl
    jq
    cargo-tauri
    desktop-file-utils
    copyDesktopItems
    imagemagick
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ];

  buildInputs = [ openssl ] ++ linuxTauriDeps;

  PKG_CONFIG_PATH = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeSearchPath "lib/pkgconfig" [
      openssl.dev
      webkitgtk_4_1.dev
      gtk3.dev
      glib.dev
      cairo.dev
      gdk-pixbuf.dev
      harfbuzz.dev
      pango.dev
      at-spi2-atk.dev
    ]
  );

  OPENSSL_DIR = "${openssl.dev}";
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  TAURI_SKIP_DEVSERVER_CHECK = "true";

  # dlopen() ignores RPATH — inject the appindicator lib path into
  # wrapGAppsHook3's own wrapper args (gappsWrapperArgs, not makeWrapperArgs).
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath linuxTauriDeps}"
    )
  '';

  preConfigure = ''
    export HOME=$TMPDIR

    # corepack's packageManager pin needs network access; strip it.
    if [ -f package.json ]; then
      jq 'del(.packageManager)' package.json > package.json.tmp \
        && mv package.json.tmp package.json
    fi
  '';

  # `cargo tauri build` drives the whole build, so the cargo build/check hooks
  # would only duplicate (or break) it.
  doCheck = false;
  auditable = false;

  buildPhase = ''
    runHook preBuild

    # `cargo tauri build --no-bundle` (not a bare `cargo build`) is required:
    # it runs the frontend build and embeds dist/ into the binary via Tauri's
    # asset pipeline, which a raw cargo build skips.
    cargo tauri build --no-bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp target/release/dbx $out/bin/dbx

    if [ -d src-tauri/icons ]; then
      for size in 32 128; do
        if [ -f "src-tauri/icons/''${size}x''${size}.png" ]; then
          mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
          cp "src-tauri/icons/''${size}x''${size}.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/dbx.png"
        fi
      done

      if [ -f "src-tauri/icons/128x128@2x.png" ]; then
        mkdir -p "$out/share/icons/hicolor/256x256/apps"
        cp "src-tauri/icons/128x128@2x.png" \
          "$out/share/icons/hicolor/256x256/apps/dbx.png"
      fi

      for size in 16 48 64; do
        mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
        if [ "$size" -le 32 ] && [ -f "src-tauri/icons/32x32.png" ]; then
          src="src-tauri/icons/32x32.png"
        elif [ -f "src-tauri/icons/128x128.png" ]; then
          src="src-tauri/icons/128x128.png"
        else
          continue
        fi
        magick "$src" -resize "''${size}x''${size}" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/dbx.png"
      done

      if [ -f "src-tauri/icons/icon.png" ]; then
        mkdir -p "$out/share/icons/hicolor/512x512/apps"
        cp "src-tauri/icons/icon.png" \
          "$out/share/icons/hicolor/512x512/apps/dbx.png"
      fi
    fi

    mkdir -p $out/share/applications
    cp ${finalAttrs.desktopItem}/share/applications/dbx.desktop \
      $out/share/applications/dbx.desktop
    ${desktop-file-utils}/bin/desktop-file-validate \
      $out/share/applications/dbx.desktop

    runHook postInstall
  '';

  # rustc bakes every panic site's `file!()` path into the binary, so the
  # vendored crate sources and the toolchain end up as runtime references
  # (~4 GiB of closure) even though nothing ever opens those files.
  postFixup = ''
    if [ -f $out/bin/.dbx-wrapped ]; then
      remove-references-to -t ${finalAttrs.cargoDeps} -t ${rustc} $out/bin/.dbx-wrapped
    fi
  '';

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
    desktopFile = "${placeholder "out"}/share/applications/dbx.desktop";
  };
})
