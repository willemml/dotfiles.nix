{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  stylix.targets.nixvim = {
    enable = true;
    transparent_bg = {
      main = true;
      sign_column = true;
    };
  };

  programs.nixvim = {
    enable = true;

    plugins.lightline.enable = true;
  };
}
