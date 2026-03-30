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
          };
        };
      };
    };
  };
}
