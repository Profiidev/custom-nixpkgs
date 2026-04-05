{
  description = "Custom Nixpkgs I use in my configurations.";

  nixConfig = {
    extra-substituters = [
      "https://projects.cache.profidev.io"
    ];
    extra-trusted-public-keys = [
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vicinae.follows = "vicinae";
    };

    bun2nix = {
      url = "github:baileylutcd/bun2nix?rev=72c047583edc83e2c2eada6e348dfaa622781331";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayscriber = {
      url = "github:devmobasa/wayscriber";
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

          externalOverlays = [
            inputs.vicinae.overlays.default
            inputs.noctalia.overlays.default
          ];

          prevPkgs = prev // {
            bun2nix = inputs.bun2nix.packages.${system}.default;
            wayscriber = inputs.wayscriber.packages.${system}.default;
            wayscriber-configurator = inputs.wayscriber.packages.${system}.wayscriber-configurator;
          };

          externalPkgs = prev.lib.foldl (acc: overlay: acc // (overlay final prev)) prevPkgs externalOverlays;
        in
        externalPkgs
        // (import ./overlay.nix {
          inherit
            mkBunDerivation
            mkVicinaeExtension
            final
            ;
          prev = externalPkgs;
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

          utils = import ./utils.nix { inherit pkgs; };
          sources = import ./sources.nix { inherit pkgs; };
        in
        {
          packages = builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = pkgs.${pkg};
            }) (utils.packageNames ++ utils.overlayNames ++ utils.buildPackageNames)
          );

          sources = sources;
        }
      )
      // {
        overlays.default = overlay;

        vicinae = inputs.vicinae;
        vicinae-extensions = inputs.vicinae-extensions;
        noctalia = inputs.noctalia;
      }
    );
}
