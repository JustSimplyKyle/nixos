{
  prev,pkgs,lib,config,inputs,...
}: 
{
  programs.ironbar = {
    enable = true;
    style = builtins.readFile ./style.css;
    config = 
    let 
      barLockPath = "${config.xdg.stateHome}/ironbar_soundbar.lock";
      netLockPath = "${config.xdg.stateHome}/internet.lock";
      clockLockPath = "${config.xdg.stateHome}/clock.lock";
      in 
      let
        cavaScript = (pkgs.writeShellApplication {
          name = "cava";
          runtimeInputs = [pkgs.cava];
          text = ''
            printf "[general]\nframerate=160\nbars = 7\n[output]\nmethod = raw\nraw_target = /dev/stdout\ndata_format = ascii\nascii_max_range = 7\n" | cava -p /dev/stdin | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g; '      
          '';
        }) + "/bin/cava";
        clockState = (pkgs.writeShellApplication {
          name = "clock";
          text = ''
            if [ -f "${clockLockPath}" ]; then
              exit 0
            else
              exit 1
            fi
          '';
        }) + "/bin/clock";
        internetState = (pkgs.writeShellApplication {
          name = "net";
          text = ''
            if [ -f "${netLockPath}" ]; then
              exit 0
            else
              exit 1
            fi
          '';
        }) + "/bin/net";
        soundbarState = "poll:100:" + (pkgs.writeShellApplication {
          name = "sdState";
          text = ''
            if [ -f "${barLockPath}" ]; then
            	exit 0
            else
            	exit 1
            fi
          '';
        }) + "/bin/sdState";
        getVolume = (pkgs.writeShellApplication { 
          name = "volget";
          runtimeInputs = [pkgs.wireplumber];
          text = ''
            wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}'
          '';
        }) + "/bin/volget";
        soundbarValue = (pkgs.writeShellApplication {
          name = "sdval";
          text = ''
            if [ -f "${barLockPath}" ]; then
              echo ''
            else
              echo ''
            fi
          '';
        }) + "/bin/sdval";
        expandSoundbar = (pkgs.writeShellApplication {
          name = "sdbar";
          text = ''
            if [ -f "${barLockPath}" ]; then
            	rm -rf "${barLockPath}"
            else
            	touch "${barLockPath}"
            fi
          '';
        }) + "/bin/sdbar";
        wifi = cmd:"{{"+(pkgs.writeShellApplication {
          name = "wifi-${cmd}";
          runtimeInputs=[pkgs.ripgrep pkgs.networkmanager];
          text = ''
            status="$(nmcli g | tail -n 1 | awk '{print $1}')"
            signal=$(nmcli dev wifi | rg "\*" | awk '{ print $9 }')
            essid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)


            icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")

            if [ "$status" = "disconnected" ] ; then
              icon=""
              essid=""
              color="#988ba2"
            else
              level=$(awk -v n="$signal" 'BEGIN{print int(n/20)}')
              if [ "$level" -gt 4 ]; then
                level=4
              fi

              icon=''${icons[$level]}
              color="#cba6f7"
            fi
            echo "$icon" "$essid" "$color" > /dev/null
            

          	echo "''$${cmd}"
          '';
        }) + "/bin/wifi-${cmd}" + "}}";
      in
      let 
        workspace = {
          type = "workspaces";
          sort = "alphanumeric";
          on_scroll_up = "hyprctl dispatch workspace -1";
          on_scroll_down = "hyprctl dispatch workspace +1";
        };
        window = {
          type = "focused";
          show_icon = true;
          show_title = true;
          icon_size = 24;
          icon_theme = "Paper";
        };
        expand_sound = {
          type = "script";
          mode = "poll";
          interval = 100;
          cmd = soundbarValue;
          on_click_left = expandSoundbar;
        };
        cava = {
          transition_type = "slide_end";
          transition_duration = 750;
          type = "script";
          mode = "watch";
          cmd = cavaScript;
          show_if = soundbarState;
        };
        volume = {
          transition_type = "slide_end";
          transition_duration = 350;
          type = "custom";
          bar = [ 
              {
                  type = "slider";
                  class = "scale";
                  length = 100;
                  max = 100;
                  on_change = "!${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ $0%";
                  on_scroll_down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 2%-";
                  on_scroll_up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 2%+";
                  on_click_right = "pavucontrol";
                  value = "100:${getVolume}";
                  show_if = soundbarState;
                  tooltip = "{{${getVolume}}}%";
              }
          ];
        };
        internet = {
          type = "custom";
          class = "internet";
          on_mouse_exit = "rm ${netLockPath}";
          on_mouse_enter = "touch ${netLockPath}";
          bar = [
              {
                  type = "label";
                  transition_type = "slide_end";
                  transition_duration = 350;
                  label = wifi "essid";
                  show_if = "100:${internetState} ";
              }
              {
                  type = "label";
                  label = wifi "icon";
              }
          ];
        };
        custom_clock = {
          type = "custom";
          class = "time";
          on_mouse_exit = "rm ${clockLockPath}";
          on_mouse_enter = "touch ${clockLockPath}";
          bar = [
              {
                  type = "label";
                  label = "{{date '+%H:%M'}}";
              }
              {
                  type = "label";
                  transition_duration = 400;
                  label = " {{date '+%b %d, %Y'}}";
                  class = "clock_date";
                  show_if = "100:${clockState}";
              }
          ];
        };
        tray = {
          type = "tray";
        };
      in {
        position = "top";
        start = [ workspace ];
        center = [ window ];
        end = [ cava volume expand_sound internet custom_clock tray ];
      };
  };
}