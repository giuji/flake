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

  home-manager.users.giuji.home.packages = with pkgs; [
    nicotine-plus
    element-desktop
    firefox
    spotify
    unzip
    keepassxc
    deluge-gtk
    racket
    ghostscript
    anki-bin
  ];

  home-manager.users.giuji.services.ssh-agent = {
    enable = true;
  };
  
}
