{
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
  };
}
