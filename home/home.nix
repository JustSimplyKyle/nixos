{pkgs, inputs,lib, ...}:let
  renogare = pkgs.callPackage ./fonts/renogare.nix { };
  kvlibadwaita = pkgs.callPackage ./kvlibadwaita.nix { };
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.ironbar.homeManagerModules.default
    inputs.webcord.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    ./helix.nix
    ./hyprland
    ./ironbar
    ./anyrun.nix
  ];
  home.packages = with pkgs; [ kvlibadwaita imagemagick jq swww lua exa adw-gtk3 unzip delta wl-clipboard cava renogare libsForQt5.qtstyleplugin-kvantum microsoft-edge-dev ];
  home.stateVersion = "23.05";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
    };
  };
  programs.webcord.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = "^[[A";
      searchDownKey = "^[[B";
    };
    initExtra = ''
      eval "$(lua "$HOME/.zsh/plugins//z.lua/z.lua" --init zsh enhanced once fzf)"
    '';
    plugins = [
      {
        name = "input";
        file = "init.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zimfw";
          repo =  "input";
          rev = "master";
          sha256 = "sha256-jH1aTY7vvbA5zygdwUhOloREwjOPftXU/GGuxElTvFE=";
        };
      }
      {
        name = "z.lua";
        src = pkgs.fetchFromGitHub {
          owner = "skywind3000";
          repo = "z.lua";
          rev = "HEAD";
          sha256 = "sha256-n6MkjukFw4Yk1SdnGRIf7XgkesbH5ZIt/EOdLVZC67U=";
        };
      }
      {
        name = "exa";
        file = "init.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zimfw";
          repo =  "exa";
          rev = "HEAD";
          sha256 = "sha256-nJcgPvS8ZcVH22rV+pZtf43P1WHOpub67ssyQjJXyh8=";
        };
      }
    ];
    shellAliases = {
      lg = "lazygit";
    };
  };
  programs.git = {
    enable = true;
    userName = "JustSimplyKyle";
    userEmail = "shiue.kyle@gmail.com";
  };
  programs.gh = {
    enable=true;
  };
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = { 
        colorArg = "never";
        pager = "${pkgs.delta}/bin/delta --dark --paging=never";
      };
    };
  };
  programs.starship.enable = true;
  programs.home-manager = {
    enable = true;
    path = "/home/kyle/dotfiles/home.nix";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = 
    let
      config.packageOverrides = pkgs: {
        fcitx5-rime = pkgs.fcitx5-rime.override {
          rimeDataPkgs = [
            ./colemak
          ];
        };
      }; in
    with pkgs; [ fcitx5-rime ];
  };
  nixpkgs.overlays = [
    (self: super: {
        rime-data = ./colemak;
        fcitx5-rime = super.fcitx5-rime.override { rimeDataPkgs = [ ./colemak ];};
      }
    )
  ];
}
