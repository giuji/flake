{ config, pkgs, lib, ... }:

{

  # this assumes every host uses btrfs, which might not be true
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "it_IT.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8";
  };
    
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
	  efi.efiSysMountPoint = lib.mkForce config.disko.devices.disk.main.content.partitions.ESP.content.mountpoint;
  };

  time.timeZone = "Europe/Rome";

  hardware.enableRedistributableFirmware = true;

  services.tlp.settings = lib.mkIf config.services.tlp.enable {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };
  
}
