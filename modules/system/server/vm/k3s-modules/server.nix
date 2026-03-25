{
  pkgs,
  ...
}:
{
  imports = [
    ./server/firewall.nix
    ./server/cloudflared.nix
    ./server/k3s.nix
    ./server/traefik.nix
    ./server/packages.nix
    ./server/kubernetes-services.nix
  ];
}
