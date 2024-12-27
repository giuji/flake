{ config, lib, pkgs, ... }:

{

  users.users.calibre-web = {
    createHome = lib.mkForce false;
    shell = pkgs.shadow;
  };

  services.calibre-web = {
    enable = true;
    openFirewall = true;
    user = "calibre-web";
    options = {
      enableBookConversion = true;
      enableBookUploading = true;
      enableKepubify = true;
      # calibreLibrary = path on dataset...;
    };
  };
  
}
