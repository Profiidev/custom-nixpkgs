final: prev: {
  noctalia-shell = (
    prev.noctalia-shell.override {
      calendarSupport = true;
    }
  );
}
