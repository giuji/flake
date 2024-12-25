inputs:

let

  inherit (inputs.nixpkgs) lib;

  homeManagerModuleConfig = [
    inputs.home-manager.nixosModules.default
    { home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];

  commonProfiles = [
    ../profiles/networking.nix
    ../profiles/syncthing.nix
    ../profiles/giuji.nix    
  ];

  desktopProfiles = [
    ../profiles/git.nix
    ../profiles/fish.nix
    ../profiles/mpv.nix
    ../profiles/sway.nix
    ../profiles/emacs.nix
    { home-manager.users.giuji.home.stateVersion = "24.05"; }
  ]
  ++ homeManagerModuleConfig;

  amd = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # use radv
    { environment.variables.AMD_VULKAN_IDC = "RADV"; }
  ];

  # i hate nix it would make more sense to pass this to the various
  # submodules as an argument rather than making a module and
  # referencing its value idk
  # isDesktopModule = ({ lib, ... }: {
  #   options.isDesktop = lib.mkOption {
  #     type = lib.types.bool;
  #     default = false;
  #   };
  # });

  mkHost = { hostname, isDesktop ? false, extraModules ? [] }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs =  { inherit inputs isDesktop; };
      modules = [
        inputs.disko.nixosModules.default
        inputs.nixos-hardware.nixosModules.common-pc
        inputs.nixos-hardware.nixosModules.common-pc-ssd
#        hostVarsModule
        ./commonConfig.nix
        {
           # defining an isDesktop option would be better since passing
           # it as arguments dont get type checked but i much prefer
           # doing it this way idk
#          _module.args = { inherit isDesktop; };
          networking.hostName = "${hostname}";
          system.stateVersion = "24.05";
        }
      ]
      ++ (import ./${hostname})
      ++ commonProfiles
      ++ extraModules
      ++ (if isDesktop then desktopProfiles else []);
    };
  
in

{

  tweed = mkHost {
    hostname = "tweed";
    isDesktop = true;
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t430
    ];
  };
    
  lambswool = mkHost {
    hostname = "lambswool";
    isDesktop = true;
    extraModules = ([
      ../profiles/gaming.nix
      ../profiles/dlna.nix
    ]
    ++ amd);
  };

  velvet = mkHost {
    hostname = "velvet";
    isDesktop = true;
    extraModules = ([
      inputs.nixos-hardware.nixosModules.common-pc-laptop
    ]
    ++ amd);
  };

  corduroy = mkHost {
    hostname = "corduroy";
    isDesktop = false;
    extraModules = [
      ../profiles/steam.nix
    ];
    #++ amd;
  };
  
}
