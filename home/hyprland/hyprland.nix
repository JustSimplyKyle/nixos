{
  config, pkgs, ...
}: let
  wallpaper = (pkgs.wrtieShellApplication {
    name = "swww-wall";
    runtimeInputs = [pkgs.jq pkgs.swww pkgs.imagemagick];
    text = ''
      export SWWW_TRANSITION=any
      export SWWW_TRANSITION_STEP=60
      export SWWW_TRANSITION_FPS=255
      export SWWW_TRANSITION_BEZIER=0.85,0,0.15,1

      wget $(wget https://api.waifu.im/search/\?is_nsfw\=true\&selected_tags\=waifu\&full\=false\&many\=false\&gif\=false -O- | jq -r ".[] | .[].url") -O- | convert - \( -clone 0 -resize 2560x1440\^ -gravity center -extent 2560x1440 -scale 50% -blur 0x2.5 -resize 200%\)\( -clone 0 -resize 2560x1440 \) -delete 0 -gravity center -compose over -composite /dev/stdout | swww img - -o DP-2
      wget $(wget https://api.waifu.im/search/\?is_nsfw\=false\&selected_tags\=waifu\&full\=false\&many\=false\&gif\=false -O- | jq -r ".[] | .[].url") -O- | convert - \( -clone 0 -resize 2560x1440\^ -gravity center -extent 2560x1440 -scale 50% -blur 0x2.5 -resize 200%\)\( -clone 0 -resize 2560x1440 \) -delete 0 -gravity center -compose over -composite /dev/stdout | swww img - -o HDMI-A-1
    '';
  }) + "/bin/swww-wall";
  decoration = builtins.readFile ./decoration.conf;
  environment = builtins.readFile ./enviromental_variables.conf;
  keybinds = builtins.readFile ./keybinds.conf;
  monitors = builtins.readFile ./monitors.conf;
  rules = builtins.readFile ./rules.conf;
  startup = builtins.readFile ./startup.conf;
in ''''
