{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    rPackages.fontawesome
    nerdfonts
    ubuntu_font_family
    noto-fonts-cjk-sans
  ];
}
