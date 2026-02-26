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
  ];
  filterDarwinUnsupported = pkg: !(pkgs.stdenv.isDarwin && builtins.elem pkg darwinUnsupported);

  armUnsupported = [
    "nwjs"
    "moondeck-buddy"
  ];
  filterArmUnsupported = pkg: !(pkgs.stdenv.isAarch64 && builtins.elem pkg armUnsupported);

  allOverlayNames = map (pkg: pkgs.lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./overlays)
  );

  allPackageNames = map (pkg: pkgs.lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./packages)
  );

  applyFilters =
    list: builtins.filter filterDarwinUnsupported (builtins.filter filterArmUnsupported list);
in
{
  overlayNames = applyFilters allOverlayNames;
  packageNames = applyFilters allPackageNames;
}
