final: prev: {
  virtualbox = (
    prev.virtualbox.override {
      extensionPack = prev.virtualboxExtpack;
      enableHardening = true;
    }
  );
}
