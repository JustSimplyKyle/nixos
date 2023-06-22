{pkgs, inputs, ...}:let
  renogare = pkgs.callPackage ./fonts/renogare.nix { };
  kvlibadwaita = pkgs.callPackage ./kvlibadwaita.nix { };
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.ironbar.homeManagerModules.default
    inputs.webcord.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    ./hyprland
    ./ironbar
    ./anyrun.nix
  ];
  home.packages = with pkgs; [ kvlibadwaita imagemagick jq swww lua exa adw-gtk3 unzip delta wl-clipboard cava renogare libsForQt5.qtstyleplugin-kvantum microsoft-edge-dev ];
  home.stateVersion = "23.05";
  programs.webcord.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    historySubstringSearch.enable=true;
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
  nixpkgs.overlays = [(self: super: {
      rime-data = ./colemak;
      fcitx5-rime = super.fcitx5-rime.override { rimeDataPkgs = [ ./colemak ];};
    }
  )];
}
