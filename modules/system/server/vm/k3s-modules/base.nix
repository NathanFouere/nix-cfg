{
  config,
  pkgs,
  ...
}:
{
  config = {
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
  };
}
