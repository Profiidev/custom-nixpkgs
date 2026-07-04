{ pkgs, ... }:

let
  raycastExtension =
    name: rev: hash:
    "${
      pkgs.fetchFromGitHub {
        owner = "raycast";
        repo = "extensions";
        rev = rev;
        hash = hash;

        sparseCheckout = [
          "extensions/${name}"
        ];
      }
    }/extensions/${name}";

  pythonWheel =
    pname: version: hash:
    pkgs.python3Packages.fetchPypi {
      inherit version hash;
      pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
      format = "wheel";
      dist = "py3";
      python = "py3";
    };
in
{
  spotifyPlayerRaycastExtension =
    raycastExtension "spotify-player" "3745b33cbc5ae69d99eb0ded423eab1b494272a0"
      "sha256-Fz/3p980APjEr2q0V3mQ+QIk3rknJK9MAF15BK/zLic=";
  googleSearchRaycastExtension =
    raycastExtension "google-search" "3745b33cbc5ae69d99eb0ded423eab1b494272a0"
      "sha256-JQwPpzeHKalstRNtTlX00/Sv2VR/7DIRtOQcNCgSaL8=";
  randomDataGeneratorRaycastExtension =
    raycastExtension "random-data-generator" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-taa3pg69aVF0GO7jXnR2gpRZVBJUqnlYlkPxaYT21qI=";
  qrCodeGeneratorRaycastExtension =
    raycastExtension "qrcode-generator" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-6gmc96Y5zTRzTcGvjQsOmn/P89HV8PmmpTDxdK7oYD0=";
  homeAssistantRaycastExtension =
    raycastExtension "homeassistant" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-lSEtzYw96imTNHNW/VxxZZxyhOP6q490YnV8fYdpt3Y=";
  jwtDecoderRaycastExtension =
    raycastExtension "jwt-decoder" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-YD8aWcJSlEWs/Rwou9AW46o8NMEEsq/9e0ujWQpPWek=";
  canIUseRaycastExtension =
    raycastExtension "can-i-use" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-KKuYr34JG6V0Dn0Ekf/RNoU7tCPDgg8WrYASAmiuO4A=";
  lucideIconsSearchRaycastExtension =
    raycastExtension "lucide-icons" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-kS92gdtBzPf9SOdE6OtGDf2Fo69tIlusDGOwaEcwPbo=";
  whoisRaycastExtension =
    raycastExtension "whois" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-tep/2A/dQUfY8+nJqugwm0ZLoALULmcraCo3hrP4IZM=";
  searchMdnRaycastExtension =
    raycastExtension "search-mdn" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-FNRbJuyBqM+k6SNkEzdMz9vfNsNgiq1kdKRlzPDSMsg=";
  protonPassRaycastExtension =
    raycastExtension "proton-pass" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-kfNocAJ8uxMKW7NTgevPcA3G8Rg+I79JPJli5Z9YYlc=";
  caidoServerAuthWheel =
    pythonWheel "caido-server-auth" "0.1.2"
      "sha256-QMbNNyjiTN/0AsTvpdj1W/bmzHOsAWm96hrR40+v+P8=";
  caidoSdkClientWheel =
    pythonWheel "caido-sdk-client" "0.2.0"
      "sha256-vFc2UWgcCT7pZjx5JNONUiqJzqYOLOANNLqbApQrHaE=";
}
