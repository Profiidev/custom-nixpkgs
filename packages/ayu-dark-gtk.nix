{ ayu-theme-gtk, ... }:

let
  gtk4CssOverride = ../assets/ayu-dark-gtk4.css;
in
ayu-theme-gtk.overrideAttrs (oldAttrs: {
  pname = "ayu-dark-gtk";

  postInstall = ''
    ${oldAttrs.postInstall or ""}
    # Copy gtk-3.0 assets to gtk-4.0
    mkdir -p $out/share/themes/Ayu-Dark/gtk-4.0
    cp -r $out/share/themes/Ayu-Dark/gtk-3.0/* $out/share/themes/Ayu-Dark/gtk-4.0/
    # Override gtk-4.0 css
    cp ${gtk4CssOverride} $out/share/themes/Ayu-Dark/gtk-4.0/gtk.css
  '';
})
