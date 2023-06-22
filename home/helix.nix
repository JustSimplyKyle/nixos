{pkgs, inputs,lib, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "fleet_dark";
      editor = {
        scrolloff = 10;
        line-number = "relative";
        color-modes = true;
        cursorline = true;
        true-color = true;
        idle-timeout = 0;
        completion-replace = true;

        soft-wrap.enable = true;
        terminal = {
          command = "footclient";
          args = [ "sh" "-c" ];
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        indent-guides.render = true;
      };
    };
  };
}
