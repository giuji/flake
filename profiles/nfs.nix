{ isDesktop, config, lib, pkgs, ... }:
let

  server-ip = "192.168.1.136";
  server-port = 2049;

in
if isDesktop
then {

  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/shared" = {
    device = "${server-ip}:/share";
    fsType = "nfs4";
    options = let p = toString server-port;
      in [ "x-systemd.automount" "noauto"  "x-systemd.idle-timeout=600" "sync" "nfsvers=4.2" "port=${p}" ];
  };

}
else {

  systemd.tmpfiles.settings = {
    "nfs-export" = {
      "/export" = {
        d = {
          group = "root";
          user = "root";
          mode = "0777";
        };
      };
    };
  };

  fileSystems."/export/share" = {
    device = "/Archive/share";
    options = [ "bind" ];
  };

  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /export 192.168.1.0/24(rw,fsid=0,no_subtree_check)
        /export/share 192.168.1.0/24(rw,insecure,nohide,no_subtree_check)
      '';
    };
    settings.nfsd = {
      UDP = false;
      TCP = true;
      port = server-port;
      vers3 = false;
      vers4 = true;
    };
  };

  # we are using nfs ver. > 4 so rpcbind is not needed
  services.rpcbind.enable = lib.mkForce false;

  networking.firewall.allowedTCPPorts = [ server-port ];

}
