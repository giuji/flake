{

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "nixos-crypt";
                extraOpenArgs = [
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L nixos" "-f" ];
                  subvolumes= {
                    "root" = {
                      mountpoint = "/";
                      mountOptions = [ "subvol=root" "noatime" "discard=async" ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=home" "noatime" "discard=async" ];
                    };
                    "nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" "noatime" "discard=async" ];
                    };
                    "swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "8G";
                    };
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
