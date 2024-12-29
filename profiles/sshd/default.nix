{ config, lib, pkgs, ... }:
let

  keys = with builtins; filter (x: x != []) (split "\n" (readFile ./auth_keys));

in  
{
  services.openssh = {
    enable = true;
    ports = [ 69 ];
    openFirewall = true;
    banner = "Treat Me Nicely!\n";
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "giuji" ];
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
      PrintMotd = true;
      #UseDNS = true;
    };
    authorizedKeysInHomedir = false;
    extraConfig = ''
      DisableForwarding yes
      PermitUserEnvironment no
      RequiredRSASize 4096
      IgnoreRhosts yes
      MaxAuthTries 3
    '';
  };

  users.users.giuji.openssh.authorizedKeys.keys = keys;
  
}
