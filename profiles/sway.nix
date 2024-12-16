{ pkgs, config, lib, ... }:
# TODO:
# - [] trash
# - [] xdg portal shit
let

  default-font = "Noto Sans";
  default-serif = "Noto Serif";
  default-mono = "Cascadia Mono";
  fonts-packages = with pkgs; [
    cascadia-code
    noto-fonts
  ];
  
  colorScheme = config.home-manager.users.giuji.colorScheme.palette;

in
{

  # use radv
  environment.variables.AMD_VULKAN_IDC = "RADV";

  services.pipewire = {
    enable = true;
    audio.enable = true;
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

  programs.dconf.enable = true;

  home-manager.users.giuji = {
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Vanilla-DMZ";
        package = pkgs.vanilla-dmz;
      };
      theme = {
        name = "Adwaita-dark";
	      package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "MoreWaita";
	      package = pkgs.morewaita-icon-theme;
      };
      font = {
        name = default-font; #+ " Regular";
      };
    };
    qt = {
      enable = true;
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt6;
      };
      platformTheme.name = "adwaita";
    };
  };

  services.udisks2.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      brightnessctl
      foot
      swayidle
      bemenu
      sway-contrib.grimshot
      qt5.qtwayland ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ELECTRON_OZONE_PLATFORM_HINT=wayland
    '';
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland.enable = true;
  };

  home-manager.users.giuji.xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
  
  home-manager.users.giuji.programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = default-mono + ":size=10";
        pad = "6x6";
      };
      colors = {
        background = colorScheme.base00;
        foreground = colorScheme.base05;
      };
    };
  };

  home-manager.users.giuji.services.mako = {
    enable = true;
    anchor = "top-right";
    backgroundColor = "#${colorScheme.base00}";
    borderColor = "#${colorScheme.base06}";
    borderSize = 1;
    defaultTimeout = 10000;
    font = default-mono + " 10";
    icons = true;
    iconPath = "${pkgs.morewaita-icon-theme}/share/icons/MoreWaita";
    margin = "22";
    padding = "10";
    textColor = "#${colorScheme.base05}";
    extraConfig = ''
      [urgency=critical]
      border-color=#${colorScheme.base08}
    '';
  };

  home-manager.users.giuji.xdg.configFile."sway/menu".text = ''
    bemenu-run -p \"run\" \
       -b \
       -H 30 \
	     --fn "${default-mono} 10" \
	     --tb "#${colorScheme.base00}" \
	     --fb "#${colorScheme.base00}" \
	     --nb "#${colorScheme.base00}" \
	     --hb "#${colorScheme.base00}" \
	     --sb "#${colorScheme.base00}" \
	     --ab "#${colorScheme.base00}" \
	     --tf "#${colorScheme.base08}" \
	     --ff "#${colorScheme.base05}" \
	     --nf "#${colorScheme.base05}" \
	     --hf "#${colorScheme.base08}" \
	     --sf "#${colorScheme.base05}" \
	     --af "#${colorScheme.base05}" \
	     --cf "#${colorScheme.base00}" \
	     --cb "#${colorScheme.base00}"
  '';

  home-manager.users.giuji.services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 290;
        command = "${pkgs.libnotify}/bin/notify-send \"sway\" \"Display turning off in 10 seconds!\"";
      }
      {
        timeout = 300;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  home-manager.users.giuji.programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      colors = true;
      color_good = "#${colorScheme.base08}";
      color_degraded = "#${colorScheme.base0B}";
      color_bad = "#${colorScheme.base0D}";
      output_format = "i3bar";
    };
    modules = {
      "volume main" = {
        position = 1;
        settings = {
          format = "Vol: %volume";
          format_muted = "MUTE";
          device = "pulse";
        };
      };
      "battery 0" = {
        position = 2;
        settings = {
          format = "%status: %percentage";
          format_down = "No Battery";
          status_bat = "Bat";
          status_chr = "Char";
          status_full = "Bat";
          status_unk = "Unk";
          low_threshold = 30;
          threshold_type = "percentage";
        };
      };
      "time" = {
        position = 3;
        settings = {
          format = "%H:%M";
        };
      };
    };
  };

  home-manager.users.giuji.wayland.windowManager.sway = {
    enable = true;
    # use system-wide sway package
    package = null; 
    systemd.enable = true;

    config = rec {
      assigns = {
        "2" = [
          { class = "^Element$"; }
          { class = "^Spotify$"; window_role = "spotify"; }
        ];
      };

      bars = [{
        position = "bottom";
        colors = rec {
          background = colorScheme.base00;
          statusline = colorScheme.base05;
          focusedWorkspace = {
            background = background;
            border = background;
            text = statusline;
          };
          activeWorkspace = focusedWorkspace // { text = colorScheme.base06; };
          urgentWorkspace = focusedWorkspace // { text = colorScheme.base08; };
          inactiveWorkspace = activeWorkspace;
          bindingMode = urgentWorkspace;
          separator = colorScheme.base06;
        };
        trayPadding = 6;
        statusCommand = "i3status";
        fonts = fonts;
        extraConfig = ''
          separator_symbol " - "
          pango_markup enabled
          height 30
        '';
      }];

      colors = rec {
        background = colorScheme.base00;
        focused = {
          background = background;
          border = colorScheme.base05;
          childBorder = colorScheme.base05;
          indicator = colorScheme.base05;
          text = colorScheme.base05;
        };
        unfocused = {
          background = background;
          border = colorScheme.base06;
          childBorder = colorScheme.base06;
          indicator = colorScheme.base06;
          text = colorScheme.base06;
        };
        urgent = unfocused // { text = colorScheme.base08; };
        focusedInactive = unfocused;
      };

      focus = {
        followMouse = "no";
        mouseWarping = "container";
      };

      fonts = {
        names = [ default-mono ];
        style = "Regular";
        size = 10.0;
      };

      gaps.inner = 10;

      menu = "sh ~/.config/sway/menu";

      terminal = "foot";

      output = {
        "*" = {
          bg = "#${colorScheme.base03} solid_color";
        };
        HDMI-A-1 = {
          mode = "1920x1080@60Hz";
          pos = "0 0";
        };
        DP-1 = {
          mode = "1920x1080@60Hz";
          transform = "90";
          pos = "-1080 -250";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:backspace";
        };
        "type:touchpad" = {
          tap = "enabled";
        };
      };

      workspaceOutputAssign = let
        f = out: ws: { workspace = ws; output = out; };
      in
        builtins.map (f "DP-1") ["2" "4"]
        ++ builtins.map (f "HDMI-A-1") ["1" "3" "5" "6" "7" "8" "9"];
      
      window = {
        border = 1;
        titlebar = false;
      };
      
      floating = window // {
        criteria = [
          { title = "Steam - Update News"; }
          { app_id = "org.keepassxc.KeePassXC"; }
        ];
      };

      startup = [
        { command = "mako"; always = true; }
        { command = "keepassxc"; always = false; }
      ];
      
      down = "n";
      left = "b";
      right = "f";
      up = "p";
      modifier = "Mod4";
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes!' 'swaymsg exit'";
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${right}" = "focus right";
        "${modifier}+${up}" = "focus up";
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${right}" = "move right";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+h" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+t" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+o" = "fullscreen";
        "${modifier}+i" = "floating toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+Shift+z" = "move scratchpad";
        "${modifier}+z" = "scratchpad show";
        "${modifier}+r" = "mode \"resize\"";
        "${modifier}+Shift+s" = "exec 'grimshot --notify savecopy anything ~/Pictures/Screenshots/sc-$(date +'%d-%m-%y@%H:%M).png'";
      };

    };
    extraConfig = ''
      # Media Keys
      # Special keys to adjust volume via PipeWire
      bindsym --locked XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym --locked XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym --locked XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindsym --locked XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      # Special keys to adjust brightness via brightnessctl
      bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+

      seat seat0 xcursor_theme Vanilla-DMZ 24

      include @sysconfdir@/sway/config.d/*
    '';
  };

}
