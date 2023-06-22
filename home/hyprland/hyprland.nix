{
  config, pkgs, ...
} @ args: let
  decoration = builtins.readFile ./decoration.conf;
  general = builtins.readFile ./general.conf;
  environment = builtins.readFile ./enviromental_variables.conf;
  keybinds = import ./keybinds.nix args;
  monitors = builtins.readFile ./monitors.conf;
  rules = builtins.readFile ./rules.conf;
  startup = builtins.readFile ./startup.conf;
in ''
  ${decoration}
  ${general}
  ${environment}
  ${keybinds}
  ${monitors}
  ${rules}
  ${startup}
''
