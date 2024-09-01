{ pkgs, ... }:

{

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
  };

  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    ppsspp
  ];

}
