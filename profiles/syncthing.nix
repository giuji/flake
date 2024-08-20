{ config, lib, pkgs, ... }:

{

  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    user = "giuji";
    dataDir = "/home/giuji/Sync";
    configDir = "/home/giuji/.config/syncthing";
  };
  
}
