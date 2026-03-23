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
    secrets.cloudflare-cert.file = ../../../secrets/cloudflare-cert.age;
    secrets.cloudflare-origin-cert.file = ../../../secrets/cloudflare-origin-cert.age;
    secrets.cloudflare-origin-key.file = ../../../secrets/cloudflare-origin-key.age;
  };
}
