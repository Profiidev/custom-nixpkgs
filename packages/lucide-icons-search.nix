{
  mkRayCastExtension,
  sources,
}:

(mkRayCastExtension {
  version = "0.1.0";
  name = "lucide-icons-search";

  src = sources.lucideIconsSearchRaycastExtension;
})
