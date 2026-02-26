{
  final,
  prev,
  mkBunDerivation,
  mkVicinaeExtension,
  ...
}:

let
  utils = import ./utils.nix { pkgs = prev; };
in
(prev.lib.foldl (acc: pkg: acc // ((import ./overlays/${pkg}.nix) final prev)) { } (
  utils.overlayNames
))
// builtins.listToAttrs (
  map (pkg: {
    name = pkg;
    value = final.callPackage ./packages/${pkg}.nix {
      inherit mkBunDerivation mkVicinaeExtension;
    };
  }) (utils.packageNames)
)
