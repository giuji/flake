{ isDesktop, config, pkgs, lib, ... }:
let

  isServer = !isDesktop;

in  
{

  # this isnt needed, its all on by default already
  hardware = {
    xone.enable = true;
    steam-hardware.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam;
    gamescopeSession.enable = false;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    remotePlay.openFirewall = true;
    fontPackages = (builtins.filter lib.types.package.check config.fonts.packages) ++ (with pkgs; [
      liberation_ttf
      wqy_zenhei
    ]);
    extest.enable = true;
  };
  environment.systemPackages = [ pkgs.mangohud ];

  programs.gamemode.enable = false;

} // (
  if isServer
  then  {
    programs.steam.gamescopeSession.enable = true;

    # also includes mangohud config
    programs.gamescope = {
      enable = true;
      args = ["--rt"]; #++ ["--mangoapp"] ;
      env = {
        MANGOHUD_CONFIG = "fsr,gamemode";
      };
     };

    # GAMESCOPE NICENESS FIX
    # unfortunately capSysNice = true; is broken rn:
    # https://discourse.nixos.org/t/unable-to-activate-gamescope-capsysnice-option/37843/11
    programs.gamescope.capSysNice = true;
    # one (terrible) solution requires patching amdgpu, it's less than
    # ideal but...
    boot.kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];

    users.users.steam = {
      name = "steam";
      isNormalUser = true;
      description = "Gaming user";
      initialPassword = "qwerty";
      shell = pkgs.bashInteractive;
    };

    # this is kind of stupid
    services.getty.autologinUser = "steam";
    environment.loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && gamescope -e -f -W 1366 -H 768 -- steam -opengl -720p -cef-forge-gpu -tenfoot
    '';
  }
  else {}
)
