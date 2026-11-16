{
  final,
  prev,
  ...
}:

let
  utils = import ./utils.nix { pkgs = prev; };
  sources = import ./sources.nix { pkgs = prev; };
in
(prev.lib.foldl (acc: pkg: acc // ((import ./overlays/${pkg}.nix) final prev)) { } (
  utils.overlayNames
))
// builtins.listToAttrs (
  map (pkg: {
    name = pkg;
    value = final.lib.callPackageWith (
      final
      // {
        inherit
          sources
          ;
      }
    ) ./packages/${pkg}.nix { };
  }) (utils.packageNames)
)
