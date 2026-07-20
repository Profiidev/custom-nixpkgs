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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        pre-commit-hooks.follows = "git-hooks";
      };
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        treefmt-nix.follows = "treefmt-nix";
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "git-hooks";
      };
    };

    soulver-cpp = {
      url = "github:vicinaehq/soulver-cpp";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        soulver-cpp.follows = "soulver-cpp";
      };
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        vicinae.follows = "vicinae";
        flake-compat.follows = "flake-compat";
        systems.follows = "systems";
      };
    };

    bun2nix = {
      url = "github:baileylutcd/bun2nix?rev=72c047583edc83e2c2eada6e348dfaa622781331";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        systems.follows = "systems";
      };
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    noctalia-legacy = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noctalia-qs.follows = "noctalia-qs";
      };
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
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
          # Raycast extensions build with `ray build`; the default buildPhase's
          # --out flag doesn't reach ray, so pin the -o output flag here once.
          mkRayCastExtension =
            args:
            (mkVicinaeExtension args).overrideAttrs (_: {
              buildPhase = "npm run build -- -o=$out";
            });

          externalOverlays = [
            inputs.vicinae.overlays.default
            inputs.noctalia-legacy.overlays.default
            inputs.noctalia.overlays.default
            inputs.noctalia-greeter.overlays.default
            inputs.affinity-nix.overlays.default
          ];

          localPkgs = {
            vicinae-with-soulver = inputs.vicinae.packages.${system}.with-soulver;
            bun2nix = inputs.bun2nix.packages.${system}.default;
            wayscriber = inputs.wayscriber.packages.${system}.default;
            wayscriber-configurator = inputs.wayscriber.packages.${system}.wayscriber-configurator;
            hyprland = inputs.hyprland.packages.${system}.hyprland;
            xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
          }
          // (prev.lib.foldl
            (
              acc: pkg:
              acc
              // {
                "vicinae-${pkg}" = inputs.vicinae-extensions.packages.${system}.${pkg};
              }
            )
            { }
            [
              "nix"
              "power-profile"
              "it-tools"
              "port-killer"
              "hypr-keybinds"
              "vscode-recents"
              "zed-recents"
              "protondb-search"
              "jetbrains-recent-projects"
              "hyprland-monitors"
              "hypr"
              "timer"
              "npm"
            ]
          );

          externalPkgs = prev.lib.foldl (acc: overlay: acc // (overlay final prev)) { } externalOverlays;
        in
        externalPkgs
        // localPkgs
        // (import ./overlay.nix {
          inherit
            mkBunDerivation
            mkVicinaeExtension
            mkRayCastExtension
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
