{ config, lib, pkgs, ... }:

{

  programs.fish = {
    enable = true;
    loginShellInit = ''
      function fish_prompt
        echo -n (set_color green) (prompt_pwd)(set_color normal) '> '
      end
      fish_add_path -a ~/.local/bin/ ~/.local/appimage
    '';
    shellAliases = {
      daos = "doas";
      sudo = "doas";
    };
  };

  users.users.giuji = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "qwerty";
    shell = pkgs.fish;
    createHome = true;
  };

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

  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = ["giuji"];
      keepEnv = true;
      persist = true;
    }];
  };
  
}
