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
}
