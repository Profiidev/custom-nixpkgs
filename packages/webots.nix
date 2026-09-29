{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  glib,
  libGL,
  libGLU,
  libxkbcommon,
  dbus,
  zlib,
  libx11,
  libxcb,
  libxext,
  xcbutil,
  wayland,
  expat,
  krb5,
  cups,
  vulkan-loader,
  sndio,
  fontconfig,
  brotli,
  bzip2,
  util-linux,
}:

# Repackages upstream's prebuilt tarball. A source build pulls
# prebuilt dependency archives anyway and takes hours.
stdenv.mkDerivation (finalAttrs: {
  pname = "webots";
  version = "R2025a";

  src = fetchurl {
    url = "https://github.com/cyberbotics/webots/releases/download/${finalAttrs.version}/webots-${finalAttrs.version}-x86-64.tar.bz2";
    hash = "sha256-xRJ/tCBsV6WuVSPxt/Pai2cLyJJtmuCFleE58ibzjDg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    libGL
    libGLU
    libxkbcommon
    dbus
    zlib
    libx11
    libxcb
    libxext
    xcbutil
    wayland
    expat
    krb5
    cups
    sndio
    fontconfig
    brotli
    bzip2
    util-linux
  ];

  # Bundled libs nothing links against (dlopen'd optional features / unused Qt plugins).
  autoPatchelfIgnoreMissingDeps = [
    "libImath-2_5.so.25"
    "libgcrypt.so.20"
    "libgpg-error.so.0"
    "libxml2.so.2"
    "libgtk-3.so.0"
    "libgdk-3.so.0"
    "libpangocairo-1.0.so.0"
    "libpango-1.0.so.0"
    "libatk-1.0.so.0"
    "libcairo-gobject.so.2"
    "libcairo.so.2"
    "libgdk_pixbuf-2.0.so.0"
    "libQt6WlShellIntegration.so.6"
  ];

  # GL/Vulkan drivers are dlopen'd at runtime.
  runtimeDependencies = [
    libGL
    vulkan-loader
  ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp -r . $out/share/webots

    # Bundled fontconfig is too old to parse NixOS's /etc/fonts config.
    rm $out/share/webots/lib/webots/libfontconfig.so.1

    # Launcher writes a .desktop file into ~/.local; we ship our own.
    sed -i '/# create a desktop file/,/^fi$/d' $out/share/webots/webots

    makeWrapper $out/share/webots/webots $out/bin/webots \
      --set WEBOTS_HOME $out/share/webots
    makeWrapper $out/share/webots/webots-controller $out/bin/webots-controller \
      --set WEBOTS_HOME $out/share/webots

    install -Dm644 resources/icons/core/webots.png $out/share/pixmaps/webots.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "webots";
      desktopName = "Webots";
      comment = "Webots mobile robot simulator";
      exec = "webots %f";
      icon = "webots";
      categories = [
        "Science"
        "Education"
      ];
    })
  ];

  meta = {
    description = "Open-source robot simulator";
    homepage = "https://github.com/cyberbotics/webots";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "webots";
  };
})
