{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
  ...
}:

appimageTools.wrapType2 rec {
  pname = "escrcpy";
  version = "2.11.1";

  src = fetchurl {
    url = "https://github.com/viarotel-org/escrcpy/releases/download/v${version}/Escrcpy-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-JN+Int2G0ZnGY7XTl56pqTTdx9AX9369Ijbc+t504Pc=";
  };

  dontUnpack = true;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/escrcpy.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display and control your Android device graphically with scrcpy";
    homepage = "https://github.com/viarotel-org/escrcpy";
    changelog = "https://github.com/viarotel-org/escrcpy/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "escrcpy";
    maintainers = [ lib.maintainers.Guanran928 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
