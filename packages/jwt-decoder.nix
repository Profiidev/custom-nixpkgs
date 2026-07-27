{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "jwt-decoder";

  src = sources.jwtDecoderRaycastExtension;
})
