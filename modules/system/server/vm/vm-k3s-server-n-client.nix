{
  config,
  nixpkgs,
  pkgs,
  microvm,
  ...
}:
{
  config = {
    # cf . https://microvm-nix.github.io/microvm.nix/host-options.html
    microvm.host.enable = true;
    microvm.autostart = [
      "vm-k3s-s"
      "vm-k3s-c-1"
    ];
    microvm.vms = {
      # cf .  https://microvm-nix.github.io/microvm.nix/options.html
      # TODO => pb potentiel car les vm pourrait ne pas avoir acces aux secrets agenix
      vm-k3s-s = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "cloud-hypervisor";
          microvm.vcpu = 1;
          microvm.mem = 2048;
          microvm.vsock.cid = 3;
          microvm.volumes = [
            {
              image = "/var/lib/microvms/vm-k3s-s/disk.img";
              mountPoint = "/var/lib/k3s";
              autoCreate = true;
              size = 30 * 1024; # 30GB
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
              id = "vm-k3s-s";
              mac = "02:00:00:00:00:01";
            }
          ];
          services.k3s = {
            enable = true;
            role = "server";
            token = config.age.secrets.k3s-token.path;
            clusterInit = true;
          };

          # cf . https://nixos.wiki/wiki/Environment_variables for nix env var
          # cf . https://kubernetes.io/docs/reference/kubectl/ for KUBECONFIG
          environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

          networking.hostName = "vm-k3s-s";
          systemd.network.networks."20-lan" = {
            matchConfig.Type = "ether";
            networkConfig = {
              Address = [ "192.168.0.211/24" ];
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
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com" # thinkcentre-1
          ];

          networking.firewall.allowedTCPPorts = [
            22 # SSH
            6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
          ];
          networking.firewall.allowedUDPPorts = [
            472 # k3s, flannel: required if using multi-node for inter-node networking
          ];
          environment.systemPackages = with pkgs; [
            htop
            k9s
            kubectl
          ];
          services.getty.autologinUser = "root";
          system.stateVersion = "25.11";
        };
      };
      vm-k3s-c-1 = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "cloud-hypervisor";
          microvm.vcpu = 1;
          microvm.mem = 2048;
          microvm.vsock.cid = 4;
          microvm.volumes = [
            {
              image = "/var/lib/microvms/vm-k3s-c-1/disk.img";
              mountPoint = "/var/lib/k3s";
              autoCreate = true;
              size = 30 * 1024; # 30GB
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
              id = "vm-k3s-c-1";
              mac = "02:00:00:00:00:02";
            }
          ];
          systemd.network.networks."20-lan" = {
            matchConfig.Type = "ether";
            networkConfig = {
              Address = [ "192.168.0.212/24" ];
              Gateway = "192.168.0.1";
              DNS = [ "192.168.0.1" ];
              DHCP = "no";
            };
          };
          services.k3s = {
            enable = true;
            role = "agent";
            token = config.age.secrets.k3s-token.path;
            serverAddr = "https://192.168.0.211:6443";
            extraFlags = toString [
              "--debug" # Optionally add additional args to k3s
            ];
          };

          # cf . https://nixos.wiki/wiki/Environment_variables for nix env var
          # cf . https://kubernetes.io/docs/reference/kubectl/ for KUBECONFIG
          environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

          # cf . https://mynixos.com/nixpkgs/options/services.openssh
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
            };
          };

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com" # thinkcentre-1
          ];

          networking.hostName = "vm-k3s-c-1";
          networking.firewall.allowedTCPPorts = [
            22 # SSH
            6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
          ];
          networking.firewall.allowedUDPPorts = [
            472 # k3s, flannel: required if using multi-node for inter-node networking
          ];
          environment.systemPackages = with pkgs; [
            htop
            k9s
            kubectl
          ];
          services.getty.autologinUser = "root";
          system.stateVersion = "25.11";
        };
      };
    };
  };
}
