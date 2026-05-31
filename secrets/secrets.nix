let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/W4/ioRVmnittNFSscL1GdZF7qFy2RtaizNvcHjFZO nathanfouere@tutanota.com";
  tour = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com";

  thinkcentre-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com";
  thinkcentre-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com";

  raspberry-pi3-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6+xOLTc6bWDHw9jq9TXA1Sbp29Q23n5J8dUA+A7iMQ nathanfouere@tutanota.com";

  systems = [
    thinkcentre-1
    thinkcentre-2
    raspberry-pi3-1
  ];
in
{
  "k3s-token.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "cloudflared-tunnel-cred.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "cloudflare-origin-cert.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "cloudflare-origin-key.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "traefik-dashboard-pswd.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "nodes-pswd.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "tailscale-oauth-id.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "tailscale-oauth-key.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "cloudflare-origin-cert-2.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
}
