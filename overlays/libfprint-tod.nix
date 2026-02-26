final: prev: {
  libfprint-tod = prev.libfprint-tod.overrideAttrs {
    patches = [
      ../patches/libfprint-tod.patch
    ];
  };
}
