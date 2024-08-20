{ config, pkgs, lib, ... }:

{

  i18n.defaultLocale = "en_US.UTF-8";
  
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
	  efi.efiSysMountPoint = lib.mkForce config.disko.devices.disk.main.content.partitions.ESP.content.mountpoint;
  };

  time.timeZone = "Europe/Rome";

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    emacs
    firefox
    spotify
    nheko
    keepassxc
  ];
  
}
