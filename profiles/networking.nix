{ config, lib, pkgs, ... }:

{

  networking.networkmanager.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings = {
        AutoConnect = true;
      };
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
        NameResolvingScheme = "systemd";
      };
      General = {
        EnableNetworkConfiguration = true;
        UseDefaultInterface = true;
        AddressRandomization = "once";
      };
    };
  };

  networking.resolvconf.enable = false;

  services.resolved.enable = true;

  networking.useDHCP = false;

  #DISABLED, USING IWD BUILT IN
  systemd.network = {
    enable = false;
    networks."wlan0" = {
      matchConfig.Name = "wlan0";
      networkConfig.DHCP = "yes";
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    extraCommands = "iptables -A INPUT -i lo -j ACCEPT";
  };
    
}
