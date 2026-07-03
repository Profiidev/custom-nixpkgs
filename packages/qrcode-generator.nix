{
  mkRayCastExtension,
  sources,
  ...
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "qrcode-generator";

  src = sources.qrCodeGeneratorRaycastExtension;
})
