let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/W4/ioRVmnittNFSscL1GdZF7qFy2RtaizNvcHjFZO nathanfouere@tutanota.com";
  tour = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com";
  laptop-travail = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVwraAfuJU5Yxp0Ngd2Jc99s6f8kd9Ri84NOmZ9bGd6";

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
  "cloudflared-tunnel-cred.age".publicKeys = systems;
  "traefik-dashboard-pswd.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
  "nodes-pswd.age".publicKeys = systems;
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
  "proton-vpn.age".publicKeys = [
    laptop
    tour
  ];
  "baikal-password.age".publicKeys = [
    laptop
    tour
    laptop-travail
  ];
  "noctalia-calendar-account.age".publicKeys = [
    laptop
    tour
    laptop-travail
  ];
  # Déployés uniquement sur laptop-travail, laptop/tour en destinataires pour pouvoir les éditer
  "zimbra-password.age".publicKeys = [
    laptop
    tour
    laptop-travail
  ];
  "noctalia-zimbra-account.age".publicKeys = [
    laptop
    tour
    laptop-travail
  ];
  "github-token.age".publicKeys = [
    laptop
    tour
    thinkcentre-1
    thinkcentre-2
  ];
}
