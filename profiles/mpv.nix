{ config, lib, pkgs, ... }:

{
  
  home-manager.users.giuji.programs.mpv = {
    enable = true;
    config = {
      autofit = "50%";
      hwdec = "auto";
    };
  };
  
}
