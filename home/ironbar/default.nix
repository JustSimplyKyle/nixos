{
  prev,pkgs,lib,config,inputs,...
}:
{
  programs.ironbar = {
    enable = true;
    config = builtins.readFile ./config.corn;
    style = builtins.readFile ./style.css;
  };
}