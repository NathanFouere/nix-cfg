{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  age = {
    secrets.k3s-token.file = ../../../secrets/k3s-token.age;
    secrets.traefik-dashboard-pswd.file = ../../../secrets/traefik-dashboard-pswd.age;
    secrets.tailscale-oauth-id.file = ../../../secrets/tailscale-oauth-id.age;
    secrets.tailscale-oauth-key.file = ../../../secrets/tailscale-oauth-key.age;
  };
}
