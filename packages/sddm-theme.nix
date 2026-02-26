{
  stdenv,
  fetchFromGitHub,
  bibata-cursors,
  ...
}:

stdenv.mkDerivation {
  pname = "sddm-theme-clean";
  version = "1.0.0";

  postPatch = ''
    substituteInPlace theme.conf \
      --replace 'useIpaMask=true' 'useIpaMask=false' \
      --replace 'autoFocusPassword=false' 'autoFocusPassword=true' \
      --replace 'backgroundColor=#1e1e2e' 'backgroundColor=#0A0E14'
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR . $out/share/sddm/themes/clean
  '';

  buildInputs = [ bibata-cursors ];

  src = fetchFromGitHub {
    owner = "saatvik333";
    repo = "obscure-sddm-theme";
    rev = "855229260bb6f9070244277994273572212be15e";
    hash = "sha256-WMx1SSG1L687ScPSeaZa4FuIoZSdnUidB3n44vyLCwY=";
  };
}
