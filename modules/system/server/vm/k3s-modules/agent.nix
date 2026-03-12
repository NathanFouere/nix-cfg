{
  ...
}:
{
  config = {
    services.k3s = {
      enable = true;
      role = "agent";
      tokenFile = "/run/agenix/k3s-token";
      serverAddr = "https://192.168.0.211:6443";
      extraFlags = toString [
        "--debug" # Optionally add additional args to k3s
      ];
    };
  };
}
