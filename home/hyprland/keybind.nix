{
  config,pkgs,...
} @ args: let
  exitState = (pkgs.writeShellApplication {
    name = "state";
    text = ''
      if [ -f "${config.xdg.stateHome}/clock.lock" ]; then
      	rm "${config.xdg.stateHome}/clock.lock"
      	exit 0
      else
      	touch "${config.xdg.stateHome}/clock.lock"
      	exit 1
      fi
    '';
    }) + "/bin/state";
  nsfwWallpaper = (pkgs.writeShellApplication {
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
  sfwWallpaper = (pkgs.writeShellApplication {
    name = "swww-wall";
    runtimeInputs = [pkgs.jq pkgs.swww pkgs.imagemagick];
    text = ''
      export SWWW_TRANSITION=any
      export SWWW_TRANSITION_STEP=60
      export SWWW_TRANSITION_FPS=255
      export SWWW_TRANSITION_BEZIER=0.85,0,0.15,1

      wget $(wget https://api.waifu.im/search/\?is_nsfw\=false\&selected_tags\=waifu\&full\=false\&many\=false\&gif\=false -O- | jq -r ".[] | .[].url") -O- | convert - \( -clone 0 -resize 2560x1440\^ -gravity center -extent 2560x1440 -scale 50% -blur 0x2.5 -resize 200%\)\( -clone 0 -resize 2560x1440 \) -delete 0 -gravity center -compose over -composite /dev/stdout | swww img - -o DP-2
      wget $(wget https://api.waifu.im/search/\?is_nsfw\=false\&selected_tags\=waifu\&full\=false\&many\=false\&gif\=false -O- | jq -r ".[] | .[].url") -O- | convert - \( -clone 0 -resize 2560x1440\^ -gravity center -extent 2560x1440 -scale 50% -blur 0x2.5 -resize 200%\)\( -clone 0 -resize 2560x1440 \) -delete 0 -gravity center -compose over -composite /dev/stdout | swww img - -o HDMI-A-1
    '';
  }) + "/bin/swww-wall";
in ''

bind=SUPERSHIFT,R,exec,nmcli device wifi rescan && sleep 0.5 && nmcli device wifi list && kdeconnect-cli --refresh & > /dev/null

bindm=SUPER,mouse:272,movewindow
bindm=SUPER,mouse:273,resizewindow

bind=CTRLSHIFT,f12,pass,^(com\.obsproject\.Studio)$
bind=CTRLALT,V,exec,${nsfwWallpaper}
bind=SUPERSHIFT,Tab,exec,${sfwWallpaper}
bind=SUPER,B,exec,dolphin
bind=SUPER,D,exec, pkill anyrun || anyrun
bind=SUPER,W,exec,$HOME/.config/hypr/scripts/launch_wwb
$disable=act_opa=$(hyprctl getoption "decoration:active_opacity" -j | jq -r ".float");inact_opa=$(hyprctl getoption "decoration:inactive_opacity" -j | jq -r ".float");hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1; keyword animations:enabled 0"
$enable=hyprctl --batch "keyword decoration:active_opacity $act_opa;keyword decoration:inactive_opacity $inact_opa; keyword animations:enabled 1"
bind=ALTSHIFT,D,exec,$disable; grimblast save window - | shadower | wl-copy -t image/png; $enable
bind=CTRLALT,D,exec,$disable; grimblast save active - | shadower | wl-copy -t image/png; $enable
bind=SUPERSHIFT,S,exec,$disable; grimblast save screen - | shadower | wl-copy -t image/png; $enable
bind=SUPERSHIFT,D,exec,$disable && grimblast save area  - | shadower | wl-copy -t image/png; $enable
# bind=,Print,exec,$disable && grimblast copy area ; $enable
bind=,Print,exec,$disable && $HOME/.config/hypr/scripts/freeze_screenshot ;$enable
bind=SUPER,return,exec,footclient
bind=SUPER,C,exec,microsoft-edge-dev

# window controls
bind=CTRLSHIFT,D,togglesplit,
bind=SUPER,P,pseudo
bind=SUPERSHIFT,V,togglefloating,active
bind=SUPERSHIFT,E,exec,zsh -c 'if ${exitState} ; then hyprctl dispatch exit ; else; hyprctl notify -0 10000 "rgb(ff1ea3)" "Press again to exit" ;sleep 10 && \rm "${config.xdg.stateHome}/clock.lock" ;fi'
bind=SUPER,F,fullscreen,0
bind=SUPERSHIFT,F,fakefullscreen
bind=SUPERSHIFT,Q,killactive

bind=SUPER,h,movefocus,l
bind=SUPER,l,movefocus,r
bind=SUPER,k,movefocus,u
bind=SUPER,j,movefocus,d
bind=SUPERSHIFT,h,movewindow,l
bind=SUPERSHIFT,j,movewindow,d
bind=SUPERSHIFT,l,movewindow,r
bind=SUPERSHIFT,k,movewindow,u
bind=CTRLSHIFT,h,moveintogroup,l
bind=CTRLSHIFT,j,moveintogroup,d
bind=CTRLSHIFT,l,moveintogroup,r
bind=CTRLSHIFT,k,moveintogroup,u
bind=SUPER,o,moveoutofgroup
bind=SUPER,G,togglegroup
bind=CTRL,G,lockgroups,toggle
bind=SUPERSHIFT,G,changegroupactive

bind=CTRLSUPER,l,movewindow,mon:HDMI-A-1
bind=CTRLSUPER,h,movewindow,mon:DP-2
bind=CTRLALT,l,movecurrentworkspacetomonitor,HDMI-A-1
bind=CTRLALT,h,movecurrentworkspacetomonitor,DP-2
bind=ALT,l,focusmonitor,HDMI-A-1
bind=ALT,h,focusmonitor,DP-2

binde=,XF86audioraisevolume,exec,wpctl set-volume @DEFAULT_SINK@ 2%+
binde=,XF86audiolowervolume,exec,wpctl set-volume @DEFAULT_SINK@ 2%-
bind=,XF86audiomute,exec,wpctl set-mute @DEFAULT_SINK@ toggle
bind=,XF86audioplay,exec,playerctl play-pause
bind=,XFaudionext,exec,playerctl next
bind=,XF86audioprev,exec,playerctl previous

bind=SUPER,20,togglespecialworkspace
bind=SUPERSHIFT,20,movetoworkspace,special

${builtins.concatStringsSep "\n" (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in 
''bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
bind = ALT, ${ws}, movetoworkspace, ${toString (x + 1)}
bind = ALTSHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}''
    )
    10)}
''
