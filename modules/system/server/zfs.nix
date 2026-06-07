{
  config,
  lib,
  ...
}:

{
  # cf. https://www.return12.net/zfs-on-nixos/
  options.custom.zfs = {
    poolName = lib.mkOption {
      type = lib.types.str;
      description = "Name of the ZFS pool";
    };

    hostId = lib.mkOption {
      type = lib.types.str;
      description = "Unique 8-character hex host ID for ZFS (generate with: head -c4 /dev/urandom | od -A none -t x4)";
    };
  };

  config = {
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;
    networking.hostId = config.custom.zfs.hostId;

    services.zfs.autoScrub = {
      enable = true;
      interval = "*-*-1,15 02:30";
    };

    services.sanoid = {
      enable = true;
      templates.backup = {
        hourly = 36;
        daily = 30;
        monthly = 3;
        autoprune = true;
        autosnap = true;
      };

      datasets."${config.custom.zfs.poolName}/services" = {
        useTemplate = [ "backup" ];
      };
    };
  };
}
