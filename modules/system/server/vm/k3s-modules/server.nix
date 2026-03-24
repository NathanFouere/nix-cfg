{
  pkgs,
  ...
}:
{
  config = {

    services.cloudflared = {
      enable = true;
      tunnels = {
        "ba6598c7-7b06-4fc2-a206-a90df5d418ac" = {
          credentialsFile = "/run/agenix/cloudflared-tunnel-cred";
          default = "http_status:404";
          ingress = {
            "traefik.nathan-fouere.com" = "http://localhost:30000";
          };
        };
      };
    };

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
          # Configure Network Ports and EntryPoints
          # EntryPoints are the network listeners for incoming traffic.
          ports:
            # Defines the HTTP entry point named 'web'
            web:
              port: 80
              nodePort: 30000
              # Instructs this entry point to redirect all traffic to the 'websecure' entry point
              http:
                redirections:
                  entryPoint:
                    to: websecure
                    scheme: https
                    permanent: true

            # Defines the HTTPS entry point named 'websecure'
            websecure:
              port: 443
              nodePort: 30001

          # Enables the dashboard in Secure Mode
          api:
            dashboard: true
            insecure: false

          ingressRoute:
            dashboard:
              enabled: true
              matchRule: Host(`traefik.nathan-fouere.com`)
              entryPoints:
                - web
                - websecure
              middlewares:
                - name: dashboard-auth

          # Creates a BasicAuth Middleware for the Dashboard Security
          # Secret is created via systemd service using agenix
          extraObjects:
            - apiVersion: traefik.io/v1alpha1
              kind: Middleware
              metadata:
                name: dashboard-auth
              spec:
                basicAuth:
                  secret: dashboard-auth-secret

          # We will route with Gateway API instead.
          ingressClass:
            enabled: false

          # Enable Gateway API Provider & Disables the KubernetesIngress provider
          # Providers tell Traefik where to find routing configuration.
          providers:
            kubernetesIngress:
               enabled: false
            kubernetesGateway:
               enabled: true



          ## Gateway Listeners
          gateway:
            listeners:
              web:           # HTTP listener that matches entryPoint `web`
                port: 80
                protocol: HTTP
                namespacePolicy:
                  from: All

              websecure:         # HTTPS listener that matches entryPoint `websecure`
                port: 443
                protocol: HTTPS  # TLS terminates inside Traefik
                namespacePolicy:
                  from: All
                mode: Terminate
                certificateRefs:
                  - kind: Secret
                    name: cloudflare-origin-tls
                    group: ""

          # Enable Observability
          logs:
            general:
              level: INFO
            # This enables access logs, outputting them to Traefik's standard output by default. The [Access Logs Documentation](https://doc.traefik.io/traefik/observability/access-logs/) covers formatting, filtering, and output options.
            access:
              enabled: true

          # Enables Prometheus for Metrics
          metrics:
            prometheus:
              enabled: true
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
