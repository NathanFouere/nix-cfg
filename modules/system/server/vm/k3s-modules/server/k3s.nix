{
  config = {
    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = "/run/agenix/k3s-token";
      clusterInit = true;
      extraFlags = toString [
        "--debug" # Optionally add additional args to k3s
      ];
    };
  };
}
