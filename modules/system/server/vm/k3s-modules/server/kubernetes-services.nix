{
  pkgs,
  ...
}:
{
  config = {
    systemd.services.flux-operator-install = {
      description = "Install flux-operator via Helm";
      after = [ "create-cloudflare-origin-secret.service" ];
      wants = [ "create-cloudflare-origin-secret.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };
      script = ''
        # Wait for k3s to be ready
        echo "Waiting for k3s to be ready..."
        while ! ${pkgs.kubectl}/bin/kubectl get nodes >/dev/null 2>&1; do
            sleep 2
        done

        # Skip if the release is already deployed
        if ${pkgs.kubernetes-helm}/bin/helm status flux-operator --namespace flux-system >/dev/null 2>&1; then
            echo "flux-operator is already installed, skipping."
            exit 0
        fi

        echo "Installing flux operator..."

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

    systemd.services.create-cloudflare-origin-secret = {
      description = "Create Cloudflare Origin TLS Secret for Traefik";
      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };
      script = ''
        # Wait for k3s to be ready
        echo "Waiting for k3s to be ready..."
        while ! ${pkgs.kubectl}/bin/kubectl get nodes >/dev/null 2>&1; do
            sleep 2
        done

        CERT_PATH="/run/agenix/cloudflare-origin-cert"
        KEY_PATH="/run/agenix/cloudflare-origin-key"
        DASHBOARD_PSWD_PATH="/run/agenix/traefik-dashboard-pswd"

        # Créer le secret TLS dans le namespace kube-system (où tourne Traefik)
        ${pkgs.kubectl}/bin/kubectl create secret tls cloudflare-origin-tls \
          --cert="$CERT_PATH" \
          --key="$KEY_PATH" \
          --namespace=kube-system \
          --dry-run=client -o yaml | ${pkgs.kubectl}/bin/kubectl apply -f -

        # Créer le secret BasicAuth pour le dashboard Traefik
        ${pkgs.kubectl}/bin/kubectl create secret generic dashboard-auth-secret \
          --from-literal=username=admin \
          --from-literal=password=$(cat "$DASHBOARD_PSWD_PATH") \
          --type=kubernetes.io/basic-auth \
          --namespace=kube-system \
          --dry-run=client -o yaml | ${pkgs.kubectl}/bin/kubectl apply -f -
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };
    };
  };
}
