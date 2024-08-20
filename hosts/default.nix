inputs:

let

  inherit (inputs.nixpkgs) lib;

  homeManagerModuleConfig = [
    inputs.home-manager.nixosModules.default
    { home-manager = {
        useGlobalPkgs = true;
        useUserPackages = false;
      };
    }
  ];

  stateVersion = version:
    [{
      home-manager.users.giuji.home.stateVersion = version;
      system.stateVersion = version;
    }];

  commonProfiles = [
    ../profiles/mate.nix
    ../profiles/giuji.nix
    ../profiles/networking.nix
    ../profiles/git.nix
  ];

  commonModules = hostname:
    [
      inputs.disko.nixosModules.default
      {
        i18n.defaultLocale = "en_US.UTF-8";
        networking.hostName = "${hostname}";
        nixpkgs.config.allowUnfree = true;
        nix.settings.experimental-features = ["nix-command" "flakes"];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        time.timeZone = "Europe/Rome";
	      boot.loader.efi.efiSysMountPoint = lib.mkForce inputs.self.nixosConfigurations."${hostname}".config.disko.devices.disk.main.content.partitions.ESP.content.mountpoint;
      }
    ]
    ++ commonProfiles
    ++ (import ./${hostname})
    ++ homeManagerModuleConfig
    ++ (stateVersion "24.05");

  mkHost = { hostname, extraModules ? [] }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = (commonModules hostname) ++ extraModules;
    };
  
in

{

  thinky = mkHost { hostname = "thinky"; };
    
  dippie = mkHost { hostname = "dippie"; extraModules = [ ../profiles/gaming.nix ]; };

}
