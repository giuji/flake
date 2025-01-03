{ isDesktop, config, lib, pkgs, ... }:

{

  programs.fish.enable = true;

  users.users.giuji = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ]
    ++ (lib.optional config.services.syncthing.enable "syncthing");
    initialPassword = "qwerty";
    shell = pkgs.fish;
    createHome = true;
  };

  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = ["giuji"];
      keepEnv = true;
      persist = true;
    }];
  };

  environment.systemPackages = [ pkgs.doas-sudo-shim ];

  environment.shellAliases = {
    daos = "doas";
  };

} // (
  if isDesktop
  then let

    spotifywl = pkgs.writeShellScriptBin "spotify" ''
      exec ${pkgs.spotify}/bin/spotify --enable-features=UseOzonePlatform --ozone-platform=wayland
    '';
    
    in {
    home-manager.users.giuji.home.packages = with pkgs; [
      nicotine-plus
      element-desktop
      firefox
      unzip
      keepassxc
      deluge-gtk
      racket
      ghostscript
      anki-bin
      spotifywl
    ];

    home-manager.users.giuji.services.ssh-agent = {
      enable = true;
    };
  }
  else {}  
)
