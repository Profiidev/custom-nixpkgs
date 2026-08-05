{
  lib,
  fetchurl,
  appimageTools,
  cacert,
  nix-update-script,
}:

let
  pname = "comfy-desktop";
  version = "1.0.36";

  buildId = "260805aw9t1oyh5";

  src = fetchurl {
    url = "https://download.comfy.org/${buildId}/linux/appimage/x64";
    hash = "sha256-XJTVOkdOmHZmhyWkcVblTdzEkVRvbGlgFHoXdGDnea4=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [
    cacert
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/comfyui-desktop-2.desktop $out/share/applications/comfy-desktop.desktop
    install -m 444 -D ${appimageContents}/comfyui-desktop-2.png $out/share/icons/hicolor/512x512/apps/comfy-desktop.png
    substituteInPlace $out/share/applications/comfy-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=comfy-desktop'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The desktop app for ComfyUI";
    homepage = "https://comfy.org/download";
    license = lib.licenses.agpl3Only;
    mainProgram = "comfy-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
