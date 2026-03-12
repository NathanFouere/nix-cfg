# Helper function to create a k3s VM with common configuration
{
  # Module args
  config,
  pkgs,
  nixpkgs,
  inputs,
  # VM-specific parameters
  name,
  ip,
  mac,
  cid,
  role ? "agent",
  sshKey,
  serverAddr ? "https://192.168.0.211:6443",
  ...
}:
{
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  restartIfChanged = true;

  config = {
    imports = [
      (if role == "server" then ./server.nix else ./agent.nix)
    ];
    microvm.hypervisor = "cloud-hypervisor";
    microvm.vcpu = 1;
    microvm.mem = 2048;

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

    microvm.volumes = [
      {
        image = "/var/lib/microvms/${name}/disk.img";
        mountPoint = "/var/lib/k3s";
        autoCreate = true;
        size = 30 * 1024; # 30GB
      }
    ];

    microvm.interfaces = [
      {
        type = "tap";
        id = name;
        inherit mac;
      }
    ];

    microvm.vsock.cid = cid;

    networking.hostName = name;

    systemd.network.networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "${ip}/24" ];
        Gateway = "192.168.0.1";
        DNS = [ "192.168.0.1" ];
        DHCP = "no";
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [ sshKey ];
  };
}
