{ config, pkgs, lib, ... }:

{

  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    remotePlay.openFirewall = true;
    fontPackages = (builtins.filter lib.types.package.check config.fonts.packages) ++ (with pkgs; [
      liberation_ttf
      wqy_zenhei
    ]);
    #extest.enable = true;
  };

  # also includes mangohud config
  programs.gamescope = {
    enable = true;
    args = [ "--rt" "--mangoapp" ] ++ ["-W 1920" "-H 1080" "-f"];
    env = {
      MANGOHUD_CONFIG = "fsr,gamemode";
    };
  };

  programs.gamemode.enable = false;

  environment.systemPackages = with pkgs; [
    ppsspp
    mangohud
  ];

}
