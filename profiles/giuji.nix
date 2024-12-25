{ isDesktop, config, lib, pkgs, ... }:
let

  # if is fine here, this shouldnt cause an infinite recursion
  syncthingGroup = if config.services.syncthing.enable
                   then ["syncthing"]
                   else [];
  

  grps = [ "wheel" ] ++ syncthingGroup ++ dlnaGroup;

in
{

  programs.fish.enable = true;

  users.users.giuji = {
    isNormalUser = true;
    extraGroups = grps;
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

  environment.shellAliases = {
    daos = "doas";
    sudo = "doas";
  };

} // (
  if isDesktop
  then {
    home-manager.users.giuji.home.packages = with pkgs; [
      nicotine-plus
      element-desktop
      firefox
      spotify
      unzip
      keepassxc
      deluge-gtk
      racket
      ghostscript
      anki-bin
    ];

    home-manager.users.giuji.services.ssh-agent = {
      enable = true;
    };
  }
  else {}  
)
