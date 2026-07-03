{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "search-mdn";

  src = sources.searchMdnRaycastExtension;
})
