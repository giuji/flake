{ config, lib, pkgs, ... }:

{

  users.users.syncthing = {
    createHome = lib.mkForce false;
    shell = pkgs.shadow;
    isSystemUser = true;
    group = "syncthing";
  };

  systemd.tmpfiles.settings = {
    "syncthing" = {
      "/Sync".d = {
        group = "syncthing";
        user = "syncthing";
        mode = "770";
      };
    };
  };

  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    extraFlags = [ "--no-default-folder" ];
    user = "syncthing";
    group = "syncthing";
    dataDir = "/Sync";
    configDir = "/Sync/config/";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      options = {
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        natEnabled = false;
      };
    };
  };
  
}
