{
  description = "Custom Nixpkgs I use in my configurations.";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://projects.cache.profidev.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
    ];
    connect-timeout = 5;
    fallback = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "git-hooks";
      };
    };

    positron = {
      url = "github:profiidev/positron/latest";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    proton = {
      url = "github:profiidev/proton/latest";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    hibernation = {
      url = "github:profiidev/hibernation/latest";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    corona = {
      url = "github:profiidev/corona";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    aurora = {
      url = "github:profiidev/aurora";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    umbriel = {
      url = "github:noctalia-dev/umbriel";
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

          externalOverlays = [
          ];

          localPkgs = {
            lzbt = inputs.lanzaboote.packages.${system}.lzbt;
            positron = inputs.positron.packages.${system}.default;
            hibernation = inputs.hibernation.packages.${system}.default;
            proton-launcher = inputs.proton.packages.${system}.default;
            corona = inputs.corona.packages.${system}.default;
            aurora = inputs.aurora.packages.${system}.default;
            umbriel = inputs.umbriel.packages.${system}.default;
            xdg-desktop-portal-umbriel = inputs.umbriel.packages.${system}.xdg-desktop-portal-umbriel;
          };

          externalPkgs = prev.lib.foldl (acc: overlay: acc // (overlay final prev)) { } externalOverlays;
        in
        externalPkgs
        // localPkgs
        // (import ./overlay.nix {
          inherit
            final
            ;
          prev = (prev // externalPkgs // localPkgs);
        });

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    (
      flake-utils.lib.eachSystem systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
              allowInsecurePredicate = p: builtins.elem (nixpkgs.lib.getName p) [ "nwjs" ];
              cudaSupport = true;
              cudaCapabilities = [
                "8.9"
                "8.6"
              ]; # RTX 40xx + RTX 30xx
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

        lanzaboote = inputs.lanzaboote;
        corona = inputs.corona;
        aurora = inputs.aurora;
        umbriel = inputs.umbriel;
      }
    );
}
