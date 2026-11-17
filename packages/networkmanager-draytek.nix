{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk3,
  gtk4,
  iproute2,
  networkmanager,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "networkmanager-draytek";
  version = "0.1.0-unstable-2026-05-16";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "julianjc84";
    repo = "draytek-ssl-vpn-client-linux";
    rev = "3f4666f00e758d3e84f62aa8e746686a8d2e4eec";
    hash = "sha256-UNEzeegN7GtDDjhF1Y3GkoPEUBQczp+asyMlzPIp6ZI=";
  };

  cargoHash = "sha256-uiNmB7xAYpgg2sUc5gMU8FShMme5uKaxhgfZGFMOXgg=";

  # Upstream skips certificate verification for self-signed routers; this adds a
  # per-connection SHA-256 pin (vpn.data cert-sha256) checked before credentials are sent.
  patches = [ ../patches/networkmanager-draytek-cert-pin.patch ];

  postPatch = ''
    substituteInPlace networkmanager/src/tun_device.rs \
      --replace-fail 'Command::new("ip")' 'Command::new("${iproute2}/bin/ip")'
    substituteInPlace networkmanager/data/nm-draytek-service.name \
      --replace-fail /usr/lib/NetworkManager/nm-draytek-service $out/libexec/nm-draytek-service \
      --replace-fail plugin=libnm-vpn-plugin-draytek.so plugin=$out/lib/NetworkManager/libnm-vpn-plugin-draytek.so \
      --replace-fail /usr/libexec/nm-draytek-auth-dialog $out/libexec/nm-draytek-auth-dialog
    # drop prebuilt binaries shipped in the repo, everything is built from source
    rm networkmanager/editor/*.so networkmanager/auth-dialog/nm-draytek-auth-dialog
  '';

  cargoBuildFlags = [
    "-p"
    "draytek-vpn-nm"
  ];
  cargoTestFlags = [
    "-p"
    "draytek-vpn-protocol"
    "-p"
    "draytek-vpn-nm"
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
    networkmanager
    openssl
  ];

  postBuild = ''
    make -C networkmanager/editor NM_PLUGIN_DIR=$out/lib/NetworkManager
    make -C networkmanager/auth-dialog
  '';

  postInstall = ''
    install -Dm755 $out/bin/draytek-vpn-nm $out/libexec/nm-draytek-service
    rm -r $out/bin
    install -Dm755 -t $out/lib/NetworkManager networkmanager/editor/*.so
    install -Dm755 -t $out/libexec networkmanager/auth-dialog/nm-draytek-auth-dialog
    install -Dm644 -t $out/lib/NetworkManager/VPN networkmanager/data/nm-draytek-service.name
    install -Dm644 -t $out/share/dbus-1/system.d networkmanager/data/nm-draytek-service.conf
  '';

  passthru = {
    networkManagerPlugin = "VPN/nm-draytek-service.name";
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "NetworkManager plugin for DrayTek SSL VPN";
    homepage = "https://github.com/julianjc84/draytek-ssl-vpn-client-linux";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
