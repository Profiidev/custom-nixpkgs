{
  description = "Custom Nixpkgs I use in my configurations.";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
      "https://projects.cache.profidev.io"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    connect-timeout = 5;
    fallback = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    hyprland.url = "github:hyprwm/Hyprland";

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

    noctalia-legacy = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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
          mkVicinaeExtension = inputs.vicinae.lib.${system}.mkVicinaeExtension;

          externalOverlays = [
            inputs.vicinae.overlays.default
            inputs.noctalia-legacy.overlays.default
            inputs.noctalia.overlays.default
            inputs.noctalia-greeter.overlays.default
            inputs.affinity-nix.overlays.default
          ];

          localPkgs = {
            bun2nix = inputs.bun2nix.packages.${system}.default;
            wayscriber = inputs.wayscriber.packages.${system}.default;
            wayscriber-configurator = inputs.wayscriber.packages.${system}.wayscriber-configurator;
            hyprland = inputs.hyprland.packages.${system}.hyprland;
            xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
          };

          externalPkgs = prev.lib.foldl (acc: overlay: acc // (overlay final prev)) { } externalOverlays;
        in
        externalPkgs
        // localPkgs
        // (import ./overlay.nix {
          inherit
            mkBunDerivation
            mkVicinaeExtension
            final
            ;
          prev = (prev // externalPkgs // localPkgs);
        });
    in
    (
      flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
              cudaSupport = true;
            };
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
              value = pkgs.lib.attrByPath (pkgs.lib.splitString "." pkg) null pkgs;
            }) (utils.packageNames ++ utils.overlayNames ++ utils.buildPackageNames)
          );

          sources = sources;
        }
      )
      // {
        overlays.default = overlay;

        vicinae = inputs.vicinae;
        vicinae-extensions = inputs.vicinae-extensions;
        noctalia-legacy = inputs.noctalia-legacy;
        noctalia = inputs.noctalia;
        noctalia-greeter = inputs.noctalia-greeter;
        hyprland = inputs.hyprland;
      }
    );
}
