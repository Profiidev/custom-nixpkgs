{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "random-data-generator";

  src = sources.randomDataGeneratorRaycastExtension;
})
