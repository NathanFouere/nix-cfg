{
  config,
  pkgs,
  nixpkgs,
  inputs,
  name,
  ip,
  mac,
  cid,
  isServer,
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
      ../../../common/cleanup.nix
      inputs.nix-sweep.nixosModules.default
    ];
    
    microvm.hypervisor = "cloud-hypervisor";
    microvm.vcpu = 2;
    microvm.mem = 6 * 1024;

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

    microvm.volumes = [
      {
        image = "/var/lib/microvms/${name}/disk.img";
        mountPoint = "/var/lib/rancher/k3s";
        autoCreate = true;
        size = 30 * 1024;
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
    # si on indique pas "socket" microvm ne lance pas un down de la machine "propre" cf . https://github.com/microvm-nix/microvm.nix/blob/main/lib/runners/cloud-hypervisor.nix
    microvm.socket = "/var/lib/microvms/${name}/${name}.sock";

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

    services.getty.autologinUser = "root";
    system.stateVersion = "25.11";

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

    # cf . https://nixos.wiki/wiki/NFS
    boot.supportedFilesystems = [ "nfs" ];

    # Firewall
    networking.firewall = {
      enable = true;
      checkReversePath = false;
      allowedTCPPorts = [
        22 # SSH
        30000 # Traefik NodePort
        10250 # port called for metrics by prometheus
        9100 # port called for metrics by prometheus
      ] ++ (if isServer then [
        6443 # k3s: required so that pods can reach the API server
        443 # HTTPS
      ] else
        [ ]);
      allowedUDPPorts = [
        8472 # k3s, flannel: required if using multi-node for inter-node networking
      ];
      trustedInterfaces = [
        "cni+"
        "flannel.1"
      ];
    };

    # Service k3s (agent / server)
    services.k3s = {
      enable = true;
      role = if isServer then "server" else "agent";
      tokenFile = "/run/agenix/k3s-token";
      extraFlags = toString [
        "--debug"
      ];
    } // (if isServer then {
      clusterInit = true;
    } else {
      inherit serverAddr;
    });

    # Cloudflared (server uniquement)
    # cf . https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
    services.cloudflared = if isServer then {
      enable = true;
      tunnels = {
        "ba6598c7-7b06-4fc2-a206-a90df5d418ac" = {
          credentialsFile = "/run/agenix/cloudflared-tunnel-cred";
          default = "http_status:404";
          ingress = {
            "traefik.nathan-fouere.com" = "http://localhost:30000";
            "flux.nathan-fouere.com" = "http://localhost:30000";
            "api-strategia.nathan-fouere.com" = "http://localhost:30000";
            "strategia.nathan-fouere.com" = "http://localhost:30000";
            "api-president-challenge.nathan-fouere.com" = "http://localhost:30000";
            "president-challenge.nathan-fouere.com" = "http://localhost:30000";
            "rustfs-president-challenge.nathan-fouere.com" = "http://localhost:30000";
            "rustfs-console-president-challenge.nathan-fouere.com" = "http://localhost:30000";
            "siyuan.nathan-fouere.com" = "http://localhost:30000";
            "baikal.nathan-fouere.com" = "http://localhost:30000";
            "jellyfin.nathan-fouere.com" = "http://localhost:30000";
            "radarr.nathan-fouere.com" = "http://localhost:30000";
            "sonarr.nathan-fouere.com" = "http://localhost:30000";
            "prowlarr.nathan-fouere.com" = "http://localhost:30000";
            "qbittorrent.nathan-fouere.com" = "http://localhost:30000";
            "nathan-fouere.com" = "http://localhost:30000";
            "bazarr.nathan-fouere.com" = "http://localhost:30000";
            "grafana.nathan-fouere.com" = "http://localhost:30000";
            "prometheus-monitoring.nathan-fouere.com" = "http://localhost:30000";
            "prometheus-alerts.nathan-fouere.com" = "http://localhost:30000";
          };
        };
      };
    } else
      { };

    # Traefik (server uniquement)
    # cf . https://docs.k3s.io/add-ons/helm#customizing-packaged-components-with-helmchartconfig
    # cf . https://doc.traefik.io/traefik/setup/kubernetes/
    environment.etc = if isServer then {
      "k3s/traefik-config.yaml".text = ''
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
              # This enables access logs, outputting them to Traefik's standard output by default.
              access:
                enabled: true

            # Enables Prometheus for Metrics
            metrics:
              prometheus:
                enabled: true
      '';
    } else
      { };

    # Créer le lien symbolique vers le répertoire manifests de k3s
    systemd.tmpfiles.settings = if isServer then {
      "10-k3s-traefik-link" = {
        "/var/lib/rancher/k3s/server/manifests/traefik-config.yaml" = {
          L = {
            argument = "/etc/k3s/traefik-config.yaml";
          };
        };
      };
    } else
      { };

    # Packages serveur (server uniquement)
    environment.systemPackages = if isServer then
      (with pkgs; [
        kubernetes-helm
        fluxcd
        kubectl
        k9s
        kubeseal
        fluxcd-operator
      ])
    else
      [ ];

    # Services systemd
    systemd.services = {
      # Mot de passe node pour k3s — géré via agenix
      # k3s lit /etc/rancher/node/password en premier pour authentifier le noeud
      # cf . https://docs.k3s.io/architecture#node-password-secrets
      # cf . https://blog.carrio.dev/blog/nixos-agenix-systemd-secrets/
      k3s-node-password = {
        description = "Copy k3s node password from agenix secret to expected location";
        after = [ "run-agenix.mount" ];
        wants = [ "run-agenix.mount" ];
        before = [ "k3s.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          mkdir -p /etc/rancher/node
          cp /run/agenix/nodes-pswd /etc/rancher/node/password
          chmod 600 /etc/rancher/node/password
        '';
      };
    } // (if isServer then {
      # Services Kubernetes (server uniquement)
      # cf . https://fluxoperator.dev/docs/guides/install/
      flux-operator-install = {
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

      create-cloudflare-origin-secret = {
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

          # Cree le secret TLS dans le namespace kube-system (ou tourne Traefik)
          ${pkgs.kubectl}/bin/kubectl create secret tls cloudflare-origin-tls \
            --cert="$CERT_PATH" \
            --key="$KEY_PATH" \
            --namespace=kube-system \
            --dry-run=client -o yaml | ${pkgs.kubectl}/bin/kubectl apply -f -

          # Cree le secret BasicAuth pour le dashboard Traefik
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
    } else
      { });
  };
}
