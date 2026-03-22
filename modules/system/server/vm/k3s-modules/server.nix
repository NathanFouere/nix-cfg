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

    # cf . https://docs.k3s.io/add-ons/helm#customizing-packaged-components-with-helmchartconfig
    # cf . https://doc.traefik.io/traefik/setup/kubernetes/
    environment.etc."k3s/traefik-config.yaml".text = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChartConfig
      metadata:
        name: traefik
        namespace: kube-system
      spec:
        valuesContent: |-
          image:
            repository: docker.io/library/traefik
            tag: 3.3.5
          api:
            dashboard: true
            insecure: true
          ports:
            web:
              forwardedHeaders:
                trustedIPs:
                  - 10.0.0.0/8
    '';

    # Créer le lien symbolique vers le répertoire manifests de k3s
    systemd.tmpfiles.settings."10-k3s-traefik-link" = {
      "/var/lib/rancher/k3s/server/manifests/traefik-config.yaml" = {
        L = { # "L" => creer un lien symbolique
          argument = "/etc/k3s/traefik-config.yaml"; # => crer un lien symbolique par rapport à la config créer plus haut
        };
      };
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
