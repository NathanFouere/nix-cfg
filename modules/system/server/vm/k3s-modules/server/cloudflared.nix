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
          };
        };
      };
    };
  };
}
