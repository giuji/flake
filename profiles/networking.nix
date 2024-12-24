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
        EnableNetworkConfiguration = false;
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
    enable = true;
    wait-online.anyInterface = true;
    networks."20-lan" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*";
      };
      networkConfig.DHCP = "yes";
    };
    networks."25-wlan" = {
      matchConfig.Type = "wlan";
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    extraCommands = "iptables -A INPUT -i lo -j ACCEPT";
  };
    
}
