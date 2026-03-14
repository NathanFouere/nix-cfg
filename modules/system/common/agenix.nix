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
    secrets.tailscale.file = ../../../secrets/tailscale.age;
    secrets.k3s-token.file = ../../../secrets/k3s-token.age;
    secrets.grafana-secret-key.file = ../../../secrets/grafana-secret-key.age;
  };
}
