final: prev: {
  cargo-generate = prev.cargo-generate.overrideAttrs {
    cargoBuildFeatures = [ "git" ];
    doCheck = false;
  };
}
