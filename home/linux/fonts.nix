{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    [
      rPackages.fontawesome
      ubuntu_font_family
      noto-fonts-cjk-sans
      noto-fonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
