{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.custom.monitoring.targets = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "address of nodes to monitor";
  };

  config = {
    # cf . https://wiki.nixos.org/wiki/Prometheus
    services.prometheus = {
      enable = true;
      globalConfig.scrape_interval = "10s"; # "1m"
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = config.custom.monitoring.targets;
            }
          ];
        }
      ];
    };

    services.prometheus.exporters.node = {
      enable = true;
      port = 9000;
      enabledCollectors = [
        "ethtool"
        "softirqs"
        "systemd"
        "tcpstat"
        "meminfo"
        "cpu"
        "cpufreq"
      ];
    };
  };
}
