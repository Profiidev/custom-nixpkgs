final: prev: {
  vicinae-zed-recents = prev.vicinae-zed-recents.overrideAttrs {
    patches = [
      ../patches/zed-recents.patch
    ];
  };
}
