{
  description = "Custom Nixpkgs I use in my configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bun2nix = {
      url = "github:baileylutcd/bun2nix?rev=72c047583edc83e2c2eada6e348dfaa622781331";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-utils,
      nixpkgs,
      ...
    }:
    let
      overlay =
        final: prev:
        let
          system = prev.stdenv.hostPlatform.system;

          mkBunDerivation = inputs.bun2nix.lib.${system}.mkBunDerivation;
          mkVicinaeExtension = inputs.vicinae.packages.${system}.mkVicinaeExtension;
        in
        (import ./overlay.nix {
          inherit
            mkBunDerivation
            mkVicinaeExtension
            final
            prev
            ;
        });
    in
    (
      flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              overlay
            ];
          };

          utils = import ./utils.nix { inherit (pkgs) lib; };
        in
        {
          packages = builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = pkgs.${pkg};
            }) (utils.packageNames ++ utils.overlayNames)
          );
        }
      )
      // {
        overlays.default = overlay;
      }
    );
}
