{
  pkgs,config,inputs,...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = bulitins.readFile ./hyprland.conf
  }
}