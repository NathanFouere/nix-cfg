{
  pkgs,
  ...
}:
{
  config = {
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
    ];

    systemd.services.flux-operator-install = {
      description = "Install flux-operator via Helm (one-shot)";
      after = [ "k3s.service" ];
      requires = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];

      script = ''

        # Skip if the release is already deployed
        if ${pkgs.kubernetes-helm}/bin/helm status flux-operator --namespace flux-system; then
          echo "flux-operator is already installed, skipping."
          exit 0
        fi

        echo "Installing flux-operator via Helm..."
        ${pkgs.kubernetes-helm}/bin/helm install flux-operator \
          oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
          --namespace flux-system \
          --create-namespace
        echo "flux-operator installation complete."
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };
    };
  };
}
