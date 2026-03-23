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
  serverAddr,
  gateway,
  dns,
  ...
}:
{
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  restartIfChanged = true;

  config = {
    imports = [
      (if role == "server" then ./server.nix else (import ./agent.nix { inherit serverAddr; }))
    ];
    microvm.hypervisor = "cloud-hypervisor";
    microvm.vcpu = 1;
    microvm.mem = 3 * 1024;

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
    ## TODO => vérifier si besoin sur toutes les machines ou que le server
    networking.firewall = {
      enable = true;
      # cf . https://github.com/rorosen/k3s-nix <3
      checkReversePath = false;
      allowedTCPPorts = [
        22 # SSH
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        443
        30000 # Traefik HTTP NodePort (for Let's Encrypt HTTP challenge)
        30001 # Traefik HTTPS NodePort
      ];
      allowedUDPPorts = [
        8472 # k3s, flannel: required if using multi-node for inter-node networking
      ];
      trustedInterfaces = [ "cni+" "flannel.1" ];
    };

    environment.systemPackages = with pkgs; [
      htop
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
      matchConfig.Name = "ens3";
      # linkConfig = {
      #   MTUBytes = "1200";
      # };
      networkConfig = {
        Address = [ "${ip}/24" ];
        Gateway = gateway;
        DNS = [ dns ];
        DHCP = "no";
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [ sshKey ];
  };
}
