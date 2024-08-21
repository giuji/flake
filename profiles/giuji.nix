{ config, lib, pkgs, ... }:

{

  programs.fish.enable = true;

  users.users.giuji = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "qwerty";
    shell = pkgs.fish;
    createHome = true;
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

  environment.shellAliases = {
    daos = "doas";
    sudo = "doas";
  };
  
}
