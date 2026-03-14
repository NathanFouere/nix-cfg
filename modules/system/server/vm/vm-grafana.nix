{
  config,
  nixpkgs,
  pkgs,
  microvm,
  ...
}:
{
  config = {
    microvm.host.enable = true;
    microvm.autostart = [
      "vm-grafana"
    ];
    microvm.vms = {
      vm-grafana = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "cloud-hypervisor";
          microvm.vcpu = 1;
          microvm.mem = 1024;
          microvm.vsock.cid = 5;
          microvm.volumes = [
            {
              image = "/var/lib/microvms/vm-grafana/disk.img";
              mountPoint = "/var/lib/grafana";
              autoCreate = true;
              size = 20 * 1024; # 20GB
            }
          ];
          microvm.shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
            # Pour donner accès aux secrets
            {
              source = "/run/agenix";
              mountPoint = "/run/agenix";
              tag = "agenix";
              proto = "virtiofs";
            }
          ];
          microvm.interfaces = [
            {
              type = "tap";
              id = "vm-k3s-c-2";
              mac = "02:00:00:00:00:04";
            }
          ];

          # cf . https://nixos.wiki/wiki/Grafana
          services.grafana = {
            enable = true;
            settings = {
              server = {
                # Listening Address
                http_addr = "127.0.0.1";
                # and Port
                http_port = 3000;
                # Grafana needs to know on which domain and URL it's running
                domain = "nathan-fouere.com";
                serve_from_sub_path = true;
              };
              security = {
                # cf . https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider
                secret_key = "$__file{/run/agenix/grafana-secret-key}";
              };
            };
          };

          services.nginx.virtualHosts."nathan-fouere.com" = {
            addSSL = true;
            enableACME = true;
            locations."/grafana/" = {
                proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
                proxyWebsockets = true;
                recommendedProxySettings = true;
            };
          };

          services.prometheus = {
             enable = true;
             port = 9001;
           };

          networking.hostName = "vm-k3s-c-2";
          systemd.network.networks."20-lan" = {
            matchConfig.Type = "ether";
            networkConfig = {
              Address = [ "192.168.0.221/24" ];
              Gateway = "192.168.0.1";
              DNS = [ "192.168.0.1" ];
              DHCP = "no";
            };
          };
          # cf . https://mynixos.com/nixpkgs/options/services.openssh
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
            };
          };

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
          ];

          networking.firewall.allowedTCPPorts = [
          ];
          networking.firewall.allowedUDPPorts = [
          ];
          environment.systemPackages = with pkgs; [
          ];
          services.getty.autologinUser = "root";
          system.stateVersion = "25.11";
        };
      };
    };
  };
}
