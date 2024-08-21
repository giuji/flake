{ config, lib, pkgs, ... }:

{

  home-manager.users.giuji.programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting
      fish_add_path -a ~/.local/bin/
      fish_default_key_bindings
    '';
    functions = {
      fish_prompt = {
        body = "echo -n (set_color green) (prompt_pwd)(set_color normal) '> '";
      };
    };
  };
  
}
