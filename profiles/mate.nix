{ config, lib, pkgs, ... }:

{

  services = {
    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
      xkb = {
        layout = "us";
	      options = "compose:caps";
      };
    };
    xserver.displayManager = {
      lightdm.enable = false;
      startx.enable = true;
    };
    xserver.desktopManager.mate = {
      enable = true;
      enableWaylandSession = false;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = false;
    pulse.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #   picom
  # ];

  home-manager.users.giuji = {
    gtk = {
      enable = true;
      cursorTheme = {
        name = "mate-white";
        package = pkgs.mate.mate-themes;
      };
      theme = {
        name = "BlueMenta";
	      package = pkgs.mate.mate-themes;
      };
      iconTheme = {
        name = "mate";
	      package = pkgs.mate.mate-icon-theme;
      };
      font = {
        name = "Inter Regular";
        package = pkgs.inter;
      };
    };
    qt = {
      enable = true;
      style.name = "gtk2";
      platformTheme.name = "gtk2";
    };
  };

  # home-manager.users.giuji.services.picom =
  #   let
  #     excluded = [
  #       "window_type *= 'menu'"
  #       "window_type *= 'dropdown_menu'"
  #       "window_type *= 'popup_menu'"
  #       "window_type *= 'utility'"
  #       "window_type *= 'tooltip'"
  #     ];
  #   in {
  #     enable = true;
  #     backend = "egl";
  #     fade = true;
  #     fadeDelta = 5;
  #     fadeExclude = excluded;
  #     shadow = true;
  #     #shadowOffsets = [ -18 -18 ];
  #     shadowOpacity = 0.65;
  #     shadowExclude = excluded;
  #     vSync = true;
  # };
  
  home-manager.users.giuji.home.file.".xinitrc" = {
    enable = true;
    text = ''
     exec mate-session
    '';
  };

}
