{
  config = {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "ba6598c7-7b06-4fc2-a206-a90df5d418ac" = {
          credentialsFile = "/run/agenix/cloudflared-tunnel-cred";
          default = "http_status:404";
          ingress = {
            "traefik.nathan-fouere.com" = "https://localhost:30001";
            "flux.nathan-fouere.com" = "https://localhost:30001";
            "api-strategia.nathan-fouere.com" = "https://localhost:30001";
            "strategia.nathan-fouere.com" = "https://localhost:30001";
            "president-challenge.nathan-fouere.com" = "https://localhost:30001";
            "minio-president-challenge.nathan-fouere.com" = "https://localhost:30001";
            "minio-console-president-challenge.nathan-fouere.com" = "https://localhost:30001";
          };
        };
      };
    };
  };
}
