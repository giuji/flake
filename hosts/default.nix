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
    ../profiles/sway.nix
    ../profiles/giuji.nix
    ../profiles/fish.nix
    ../profiles/networking.nix
    ../profiles/git.nix
    ../profiles/mpv.nix
    ../profiles/syncthing.nix
  ];

  amd = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # use radv
    { environment.variables.AMD_VULKAN_IDC = "RADV"; }
  ];

  commonModules = hostname:
    [
      inputs.disko.nixosModules.default
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      {networking.hostName = "${hostname}";}
      ./commonConfig.nix
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

  tweed = mkHost {
    hostname = "tweed";
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t430
    ];
  };
    
  lambswool = mkHost {
    hostname = "lambswool";
    extraModules = ([
      ../profiles/gaming.nix
      ../profiles/dlna.nix
    ]
    ++ amd);
  };

  velvet = mkHost {
    hostname = "velvet";
    extraModules = ([
      inputs.nixos-hardware.nixosModules.common-pc-laptop
    ]
    ++ amd);
  };
  
}

