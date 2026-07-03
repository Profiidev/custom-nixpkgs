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
in
{
  spotifyPlayerRaycastExtension =
    raycastExtension "spotify-player" "3745b33cbc5ae69d99eb0ded423eab1b494272a0"
      "sha256-Fz/3p980APjEr2q0V3mQ+QIk3rknJK9MAF15BK/zLic=";
  vscodeRecentProjectsRaycastExtension =
    raycastExtension "visual-studio-code-recent-projects" "3745b33cbc5ae69d99eb0ded423eab1b494272a0"
      "sha256-/Wi5zSqFXiWFmuQu1dYkx1B85XXcI+dpsjqMirUKt9g=";
  zedRecentProjectsRaycastExtension =
    raycastExtension "zed-recent-projects" "5f940aa695abefba647e6f0e5d8adc3dce80642d"
      "sha256-ZTwj++zrsdcGwGUNLQvlkmpG60zqrw+l00+XigU3COY=";
  googleSearchRaycastExtension =
    raycastExtension "google-search" "3745b33cbc5ae69d99eb0ded423eab1b494272a0"
      "sha256-JQwPpzeHKalstRNtTlX00/Sv2VR/7DIRtOQcNCgSaL8=";
  randomDataGeneratorRaycastExtension =
    raycastExtension "random-data-generator" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-taa3pg69aVF0GO7jXnR2gpRZVBJUqnlYlkPxaYT21qI=";
  qrCodeGeneratorRaycastExtension =
    raycastExtension "qrcode-generator" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-6gmc96Y5zTRzTcGvjQsOmn/P89HV8PmmpTDxdK7oYD0=";
  unixTimestampRaycastExtension =
    raycastExtension "unix-timestamp" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-lhQ2Wjb49SpOuH4Ov6/twyrD1WiTqQryVpnX4sB6QSI=";
  homeAssistantRaycastExtension =
    raycastExtension "homeassistant" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-lSEtzYw96imTNHNW/VxxZZxyhOP6q490YnV8fYdpt3Y=";
  searchMdnRaycastExtension =
    raycastExtension "search-mdn" "eb6d5bf5175c789b9f2455ba4730b4f476b7ce0b"
      "sha256-FNRbJuyBqM+k6SNkEzdMz9vfNsNgiq1kdKRlzPDSMsg=";
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
}
