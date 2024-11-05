{ config, pkgs, lib, ... }:
let
  
  # emacs org stuff, took this from https://nixos.wiki/wiki/TexLive
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
  });

  # add this to your emacs init file
  #(setq org-latex-compiler "lualatex")
  #(setq org-preview-latex-default-process 'dvisvgm)
  
in

{
	
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
    nicotine-plus
    emacs
    element-desktop
    tex # look at the let binding
    firefox
    spotify
    unzip
    keepassxc
    qbittorrent
    racket
    ghostscript
    anki-bin
  ];

  services.tlp.settings = lib.mkIf config.services.tlp.enable {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };
  
}
