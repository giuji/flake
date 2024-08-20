{ config, lib, pkgs, ... }:

{

  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    extraFlags = [ "--no-default-folder" ];
    user = "giuji";
    dataDir = "/home/giuji/Sync";
    configDir = "/home/giuji/.config/syncthing";
    settings = {
      options = {
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        natEnabled = false;
      };
    };
  };
  
}
