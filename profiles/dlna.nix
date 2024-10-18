{ pkgs, ... }: {
  
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      media_dir = [
        "V,/data/videos"
      ];
      inotify = "yes";
    };
  };

  systemd.tmpfiles.settings = {
    "minidlna-dir" = {
      "/data/videos".d = {
        group = "minidlna";
        user = "minidlna";
        mode = "755";
      };
    };
  };
    
}
