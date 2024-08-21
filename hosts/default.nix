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
    ../profiles/mpv.nix
    ../profiles/syncthing.nix
  ];

  amd = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
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

  thinky = mkHost {
    hostname = "thinky";
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t430
    ];
  };
    
  dippie = mkHost {
    hostname = "dippie";
    extraModules = ([
      ../profiles/gaming.nix
    ]
    ++ amd);
  };

}
