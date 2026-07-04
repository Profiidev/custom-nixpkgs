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

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-aTtVzjAQ78k8fR6xc1i6jxXY35ZtMfTStnKj/Heh6/k=";
  };
}
