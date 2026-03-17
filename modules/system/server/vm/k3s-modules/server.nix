{
  pkgs,
  ...
}:
{
  config = {
    networking.firewall.allowedTCPPorts = [
      22 # SSH
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    ];

    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = "/run/agenix/k3s-token";
      clusterInit = true;
    };

    environment.systemPackages = with pkgs; [
      kubernetes-helm
      fluxcd
      git
      kubectl
      k9s
      fluxcd-operator
    ];

    systemd.services.flux-operator-install = {
      description = "Install flux-operator via Helm";
      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };
      script = ''
        # Skip if the release is already deployed
        if ${pkgs.kubernetes-helm}/bin/helm status flux-operator --namespace flux-system >/dev/null 2>&1; then
            echo "flux-operator is already installed, skipping."
            exit 0
        fi

        # echo "Installing flux operator..."

        # cf. https://fluxoperator.dev/docs/guides/install/
        echo "Installing flux-operator via Helm..."
        if ! ${pkgs.kubernetes-helm}/bin/helm install flux-operator \
          oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
          --namespace flux-system \
          --create-namespace >/dev/null 2>&1; then
            echo "flux-operator installation failed."
            exit 1
        fi

        echo "flux-operator installation complete."
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };
}
