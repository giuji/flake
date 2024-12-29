{

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L nixos" "-f" ];
                subvolumes = {
                  "root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "discard=async" ];
                  };
                  "home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=home" "discard=async" ];
                  };
                  "nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "discard=async" ];
                  };
                  "swap" = {
                    mountpoint = "/swap";
                    # REMEMBER TO CHANGE THIS
                    swap.swapfile.size = "1G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  
}
