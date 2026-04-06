{
  config = {
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
        L = {
          # "L" => creer un lien symbolique
          argument = "/etc/k3s/traefik-config.yaml"; # => crer un lien symbolique par rapport à la config créer plus haut
        };
      };
    };
  };
}
