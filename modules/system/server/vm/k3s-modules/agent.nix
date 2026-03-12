{
  config,
  ...
}:
{
  config = {
    services.k3s = {
      enable = true;
      role = "agent";
      token = config.age.secrets.k3s-token.path;
      serverAddr = "https://192.168.0.211:6443";
      extraFlags = toString [
        "--debug" # Optionally add additional args to k3s
      ];
    };
  };
}
