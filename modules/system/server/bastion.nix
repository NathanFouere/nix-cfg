{
  pkgs,
  config,
  ...
}:

let
  k3sMasterNodeAddr = "192.168.1.211";
in
{
  # ici dans les faits, la plupart de la config nest pas utile car tout passe par un tunnel cloudflared
  # cf . https://www.wirsingsecurity.com/tutorials/jump-servers-and-bastion-hosts-for-homelab-access/

  # cf . https://wiki.nixos.org/wiki/Fail2ban
  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      # Allow list for some subnets
    ];
    bantime = "24h";
  };

  # cf . https://wiki.nixos.org/wiki/Automatic_system_upgrades
  system.autoUpgrade = {
    enable = true;
    flake = "../../../flake.nix";
    flags = [
      "--print-build-logs"
    ];
    randomizedDelaySec = "45min";
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.PermitRootLogin = "prohibit-password"; # dans lideal devrait etre en no mais cest plus simple pour les deployments sur le bastion
  services.openssh.settings.PubkeyAuthentication = "yes";
  services.openssh.settings.AuthenticationMethods = "publickey";
  services.openssh.settings.ClientAliveInterval = 300;
  services.openssh.settings.ClientAliveCountMax = 2;
  services.openssh.settings.MaxAuthTries = 3;
  services.openssh.settings.MaxSessions = 5;
  services.openssh.settings.LoginGraceTime = 30;
  programs.ssh.forwardX11 = false;

  security.duosec.allowTcpForwarding = true;

  # cf https://wiki.nixos.org/wiki/Tailscale
  networking.firewall = {
    enable = true;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  networking.nftables.enable = true;

  # cf . https://mynixos.com/nixpkgs/option/networking.nftables.tables
  networking.nftables.tables.filters.family = "inet";
  networking.nftables.tables.filters.content = ''
    chain input {
      type filter hook input priority 0;

      # cf . https://wiki.nftables.org/wiki-nftables/index.php/Matching_packet_metainformation
      iifname { "lo", "tailscale0*" } accept comment "trusted interfaces"

      # accept traffic originated from us
      # cf . https://www.baeldung.com/linux/new-established-related
      ct state {established, related} accept

      # pour tailscale
      udp dport 41641 accept
      
      # ICMP
      icmp type echo-request accept

      # Allow inbound SSH
      tcp dport 22 accept

      # count and drop any other traffic
      counter drop
    }
    chain output {
      type filter hook output priority 0;

      # accept any localhost traffic
      # cf . https://wiki.nftables.org/wiki-nftables/index.php/Matching_packet_metainformation
      oifname lo accept

      # cf . https://www.baeldung.com/linux/new-established-related
      ct state {established, related} accept

      # Allow outbound SSH (bastion needs to connect to internal hosts)
      tcp dport 22 accept
      
      iifname { "tailscale0*" } accept comment "trusted interfaces"

      # Allow outbound DNS and HTTP/S for package updates
      udp dport 53 accept
      tcp dport 53 accept

      # Allow outbound HTTP/S for package updates
      tcp dport 80 accept
      tcp dport 443 accept

      # Allow outbound NTP
      udp dport 123 accept

      # ICMP
      icmp type echo-request accept

      # pour tailscale
      udp sport 41641 accept

      # pour k3s
      ip daddr ${k3sMasterNodeAddr} tcp dport 6443 accept comment "k3s API"
      ip daddr ${k3sMasterNodeAddr} tcp dport 30000 accept comment "k3s traeffik"

      # pour cloudflared
      udp dport 7844 accept

      # count and drop any other traffic
      counter drop
    }
  '';

  ## Cloudflared
  services.cloudflared = {
    enable = true;
    tunnels = {
      "ba6598c7-7b06-4fc2-a206-a90df5d418ac" = {
        credentialsFile = "/run/agenix/cloudflared-tunnel-cred";
        default = "http_status:404";
        ingress =
          let
            k3sBackend = "http://${k3sMasterNodeAddr}:30000";
          in
          {
            "traefik.nathan-fouere.com" = k3sBackend;
            "flux.nathan-fouere.com" = k3sBackend;
            "api-strategia.nathan-fouere.com" = k3sBackend;
            "strategia.nathan-fouere.com" = k3sBackend;
            "api-president-challenge.nathan-fouere.com" = k3sBackend;
            "president-challenge.nathan-fouere.com" = k3sBackend;
            "rustfs-president-challenge.nathan-fouere.com" = k3sBackend;
            "rustfs-console-president-challenge.nathan-fouere.com" = k3sBackend;
            "siyuan.nathan-fouere.com" = k3sBackend;
            "baikal.nathan-fouere.com" = k3sBackend;
            "jellyfin.nathan-fouere.com" = k3sBackend;
            "radarr.nathan-fouere.com" = k3sBackend;
            "sonarr.nathan-fouere.com" = k3sBackend;
            "prowlarr.nathan-fouere.com" = k3sBackend;
            "qbittorrent.nathan-fouere.com" = k3sBackend;
            "nathan-fouere.com" = k3sBackend;
            "bazarr.nathan-fouere.com" = k3sBackend;
            "grafana.nathan-fouere.com" = k3sBackend;
            "prometheus-monitoring.nathan-fouere.com" = k3sBackend;
            "prometheus-alerts.nathan-fouere.com" = k3sBackend;
          };
      };
    };
  };
}
