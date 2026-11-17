{
  pkgs,
  ...
}:

let
  siyuan-backup = pkgs.writeShellApplication {
    name = "siyuan-backup";
    runtimeInputs = with pkgs; [
      kubectl
      gnutar
      zip
      coreutils
    ];
    text = builtins.readFile ../../scripts/backup-siyuan.sh;
  };
in
{
  home.packages = [ siyuan-backup ];

  systemd.user.services.siyuan-backup = {
    Unit = {
      Description = "Backup quotidien du workspace SiYuan dans ~/Documents";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${siyuan-backup}/bin/siyuan-backup";
    };
  };

  systemd.user.timers.siyuan-backup = {
    Unit.Description = "Backup quotidien SiYuan";
    Timer = {
      OnCalendar = "daily";
      # Rattrape le backup au démarrage si la machine était éteinte
      Persistent = true;
      RandomizedDelaySec = "10min";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
