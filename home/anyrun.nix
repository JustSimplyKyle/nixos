{pkgs,inputs, ...}: {
  programs.anyrun = {
    enable = true;
    config = {
      width.absolute = 660;
      position = "center";
      verticalOffset.absolute = -200;
      hideIcons = true;
      closeOnClick = true;
      ignoreExclusiveZones= false;
      showResultsImmediately= true; 
      layer="overlay"; 
      hidePluginInfo=false;
      plugins = [
        "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/applications"
        "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/rink"
        "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/shell"
        "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/dictionary"
      ];
    };
    extraCss = ''
      #entry {
        background-color: alpha(@theme_fg_color,0.1);
        border: 1px solid rgba(255,255,255,0.15);
        border-radius: 16px;
      }

      #main {
        background-color: alpha(@theme_bg_color,0.3);
        border: 1px solid rgba(255,255,255,0.15);
        border-radius: 16px;
      }

      #plugin {
        background-color: transparent;
      }

      #window {
        background: none;
      }
    '';
  };
}