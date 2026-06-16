{ pkgs, ... }:

let
  darwinUnsupported = [
    "libfprint-tod"
    "andromeda"
    "ayu-dark-gtk"
    "clipboard-history-cosmic-applet"
    "cosmic-ext-applet-emoji-selector"
    "cosmic-ext-applet-ollama"
    "gui-scale-applet"
    "moondeck-buddy"
    "sddm-theme"
    "nwjs"
    "vicinae"
    "noctalia-shell"
    "noctalia-qs"
    "quickshell"
    "wayscriber"
    "wayscriber-configurator"
    "affinity-v3"
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "noctalia"
  ];
  filterDarwinUnsupported = pkg: !(pkgs.stdenv.isDarwin && builtins.elem pkg darwinUnsupported);

  armUnsupported = [
    "nwjs"
    "moondeck-buddy"
    "affinity-v3"
  ];
  filterArmUnsupported = pkg: !(pkgs.stdenv.isAarch64 && builtins.elem pkg armUnsupported);

  allOverlayNames = map (pkg: pkgs.lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./overlays)
  );

  allPackageNames = map (pkg: pkgs.lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./packages)
  );

  allBuildPackageNames = (import ./packages.nix);

  applyFilters =
    list: builtins.filter filterDarwinUnsupported (builtins.filter filterArmUnsupported list);
in
{
  overlayNames = applyFilters allOverlayNames;
  packageNames = applyFilters allPackageNames;
  buildPackageNames = applyFilters allBuildPackageNames;
}
