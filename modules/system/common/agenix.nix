{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.deploy-rs.packages.${pkgs.system}.default
  ];
  age = {
    secrets.tailscale.file = ../../../secrets/tailscale.age;
    secrets.k3s-token.file = ../../../secrets/k3s-token.age;
  };
}
