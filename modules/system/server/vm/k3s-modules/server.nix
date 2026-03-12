{
  config,
  ...
}:
{
  config = {
    services.k3s = {
      enable = true;
      role = "server";
      token = config.age.secrets.k3s-token.path;
      clusterInit = true;
    };
  };
}
