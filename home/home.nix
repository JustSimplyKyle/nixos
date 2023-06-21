{pkgs, inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  home.stateVersion = "23.05";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
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
  };
  programs.starship.enable = true;
  programs.home-manager = {
    enable = true;
    path = "/home/kyle/dotfiles/home.nix";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };
}
