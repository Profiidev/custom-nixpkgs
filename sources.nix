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
    raycastExtension "spotify-player" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-atPAUm3eqVUUepfAs/N3lOs2G2qHztKHvn6cL9GD+GU=";
  googleSearchRaycastExtension =
    raycastExtension "google-search" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-L1uXvVu640AIm+FUMYKxZ0mnvwpA6cAdJpOPBvnbtuk=";
  randomDataGeneratorRaycastExtension =
    raycastExtension "random-data-generator" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-taa3pg69aVF0GO7jXnR2gpRZVBJUqnlYlkPxaYT21qI=";
  qrCodeGeneratorRaycastExtension =
    raycastExtension "qrcode-generator" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-6gmc96Y5zTRzTcGvjQsOmn/P89HV8PmmpTDxdK7oYD0=";
  homeAssistantRaycastExtension =
    raycastExtension "homeassistant" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-lSEtzYw96imTNHNW/VxxZZxyhOP6q490YnV8fYdpt3Y=";
  jwtDecoderRaycastExtension =
    raycastExtension "jwt-decoder" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-+bxaGQdNA6Cq8zq30mnmvnixjVwCgVTqmM/6jl+yC8M=";
  canIUseRaycastExtension =
    raycastExtension "can-i-use" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-KKuYr34JG6V0Dn0Ekf/RNoU7tCPDgg8WrYASAmiuO4A=";
  lucideIconsSearchRaycastExtension =
    raycastExtension "lucide-icons" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-kS92gdtBzPf9SOdE6OtGDf2Fo69tIlusDGOwaEcwPbo=";
  whoisRaycastExtension =
    raycastExtension "whois" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
      "sha256-hbbsado3rTNVR/jjFt5JvCTAaUMY5IlMuYGnv0WZz+M=";
  caidoServerAuthWheel =
    pythonWheel "caido-server-auth" "0.1.2"
      "sha256-QMbNNyjiTN/0AsTvpdj1W/bmzHOsAWm96hrR40+v+P8=";
  caidoSdkClientWheel =
    pythonWheel "caido-sdk-client" "0.2.0"
      "sha256-vFc2UWgcCT7pZjx5JNONUiqJzqYOLOANNLqbApQrHaE=";

  searchMdnRaycastExtension = pkgs.applyPatches {
    name = "search-mdn-src";
    src =
      raycastExtension "search-mdn" "8a2c73ff4315ff30c2ed1d08384dc8d35df32305"
        "sha256-FNRbJuyBqM+k6SNkEzdMz9vfNsNgiq1kdKRlzPDSMsg=";
    patches = [ ./patches/search-mdn.patch ];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-aTtVzjAQ78k8fR6xc1i6jxXY35ZtMfTStnKj/Heh6/k=";
  };
}
