let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5l/UUW0KQzQpqN+04f4QiknEqFJhm1ehXNX61OPQIz nathanfouere@tutanota.com";
  tour = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com";

  thinkcentre-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com";
  thinkcentre-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com";
  systems = [
    thinkcentre-1
    thinkcentre-2
  ];
in
{
  "tailscale.age".publicKeys = [
    laptop
    tour
  ]
  ++ systems;
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
}
