{
  mkRayCastExtension,
  applyPatches,
  sources,
  ...
}:

mkRayCastExtension {
  version = "0.1.0";
  name = "search-mdn";

  src = applyPatches {
    name = "search-mdn-src";
    src = sources.searchMdnRaycastExtension;
    patches = [ ../patches/search-mdn.patch ];
  };
}
