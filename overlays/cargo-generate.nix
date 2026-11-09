final: prev: {
  cargo-generate = prev.cargo-generate.overrideAttrs (old: {
    cargoBuildFeatures = [ "git" ];
    doCheck = false;
    # cargoSetupHook forces AWS_LC_SYS_USE_SYSTEM=1
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.aws-lc ];
  });
}
