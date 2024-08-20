{ config, pkgs, lib, ...}:

{

  home-manager.users.giuji = {
    programs.git = {
      enable = true;
      userEmail = "64275280+giuji@users.noreply.github.com";
      userName = "giuji";
      extraConfig = {
        core = {
          editor = "emacs";
        };
      };
    };
  };
  
}
