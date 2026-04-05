final: prev: {
  wayscriber = prev.wayscriber.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      SERVICE_FILE=$out/lib/systemd/user/wayscriber.service
      echo "Patching wayscriber.service at $SERVICE_FILE"
      substituteInPlace "$SERVICE_FILE" \
          --replace "/usr/bin/wayscriber" "$out/bin/wayscriber" \
          --replace "/bin/sh" "${prev.bash}/bin/sh"
    '';
  });
}
