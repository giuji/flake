{ config, lib, pkgs, ... }:
let

  default-font = "Noto Sans";
  default-serif = "Noto Serif";
  default-mono = "Cascadia Code";
  fonts-packages = with pkgs; [
    cascadia-code
    noto-fonts
  ];

in
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

  environment.mate.excludePackages = with pkgs; [
    mate.pluma
  ];
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = false;
    pulse.enable = true;
  };

  fonts = {
    packages = fonts-packages ++ (with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ]);
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      subpixel.rgba = "rgb";
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ default-mono ];
        sansSerif = [ default-font ];
        serif = [ default-serif ];
      };
    };
  };

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
        name = default-font; #+ " Regular";
      };
    };
    qt = {
      enable = true;
      style.name = "gtk2";
      platformTheme.name = "gtk2";
    };
  };

  home-manager.users.giuji.home.file.".xinitrc" = {
    enable = true;
    text = ''
     exec mate-session
    '';
  };

  home-manager.users.giuji.dconf.settings = {
    "org/mate/marco/window-keybindings" = {
      close = "<Mod4>q";
      toggle-maximized = "<Mod4>o";
      toggle-on-all-workspaces = "<Mod4>p";
      move-to-workspace-1 = "<Shift><Mod4>exclam";
      move-to-workspace-2 = "<Shift><Mod4>at";
      move-to-workspace-3 = "<Shift><Mod4>numbersign";
      move-to-workspace-4 = "<Shift><Mod4>dollar";
      tile-to-side-e = "<Mod4>f";
      tile-to-side-w = "<Mod4>b";
    };
    "org/mate/marco/global-keybindings" = {
      panel-run-dialog = "<Mod4>d";
      run-command-terminal = "<Mod4>Return";
      switch-to-workspace-1 = "<Mod4>1";
      switch-to-workspace-2 = "<Mod4>2";
      switch-to-workspace-3 = "<Mod4>3";
      switch-to-workspace-4 = "<Mod4>4";
    };
    "org/mate/caja/desktop" = {
      font = default-font + " 10";
    };
    "org/mate/desktop/interface" = {
      document-font-name = default-font + " 10";
      font-name = default-font + " 10";
      gtk-theme = config.home-manager.users.giuji.gtk.theme.name;
      icon-theme = config.home-manager.users.giuji.gtk.iconTheme.name;
      monospace-font-name = default-mono + " 10";
    };
    "org/mate/marco/general" = {
      theme = config.home-manager.users.giuji.gtk.theme.name;
      titlebar-font = default-font + " Bold 10";
      mouse-button-modifier = "<Super>";
    };
    "org/mate/notification-daemon" = {
      theme = "slider";
    };
    #nord theme
    "org/mate/terminal/profiles/default" = {
      background-color = "#2E2E34344040";
      default-size-columns = 100;
      default-size-rows = 38;
      foreground-color = "#D8D8DEDEE9E9";
      palette = "#3B3B42425252:#BFBF61616A6A:#A3A3BEBE8C8C:#EBEBCBCB8B8B:#8181A1A1C1C1:#B4B48E8EADAD:#8888C0C0D0D0:#E5E5E9E9F0F0:#4C4C56566A6A:#BFBF61616A6A:#A3A3BEBE8C8C:#EBEBCBCB8B8B:#8181A1A1C1C1:#B4B48E8EADAD:#8F8FBCBCBBBB:#ECECEFEFF4F4";
      use-theme-colors = false;
    };
  };

}
