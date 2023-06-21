{pkgs, inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland
  ];
  home.packages = with pkgs; [ delta wl-clipboard];
  home.stateVersion = "23.05";
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
  programs.lazygit={
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
      fcitx5-rime-data = ./colemak;
      fcitx5-rime = super.fcitx5-rime.override { rimeDataPkgs = [ ./colemak ];};
    }
  )];
}
