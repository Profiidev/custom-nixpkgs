{ lib, ... }:

{
  overlayNames = map (pkg: lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./overlays)
  );
  packageNames = map (pkg: lib.removeSuffix ".nix" pkg) (
    builtins.attrNames (builtins.readDir ./packages)
  );
}
