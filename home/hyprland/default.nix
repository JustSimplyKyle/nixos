{
  pkgs,prev,lib,config,inputs,hyprland,...
}@ args:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland.nix args;
    systemdIntegration = true;
    recommendedEnvironment = true;
  };
  gtk={
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Jetbrains mono:monospace:size=12";
      };
      cursor = {
        style = "underline";
        blink = "true";
      };
      colors = {
        foreground="cad3f5";# Text
        background="24273a";# Base
        regular0="494d64";  # Surface 1
        regular1="ed8796";  # red
        regular2="a6da95";  # green
        regular3="eed49f";  # yellow
        regular4="8aadf4";  # blue
        regular5="f5bde6";  # pink
        regular6="8bd5ca";  # teal
        regular7="b8c0e0";  # Subtext 1
        bright0="5b6078";   # Surface 2
        bright1="ed8796";   # red
        bright2="a6da95";   # green
        bright3="eed49f";   # yellow
        bright4="8aadf4";   # blue
        bright5="f5bde6";   # pink
        bright6="8bd5ca";   # teal
        bright7="a5adcb";   # Subtext 0
      };
    };
  };
}