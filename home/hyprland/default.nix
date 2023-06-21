{
  prev,pkgs,lib,config,inputs,hyprland,...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    recommendedEnvironment = true;
    package = inputs.hyprland.packages.${pkgs.system}.default.override {
      legacyRenderer = true;
    };
  };
}