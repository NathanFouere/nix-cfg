{
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common/base.nix
    ../../modules/system/server/base-server.nix
    ../../modules/system/common/agenix.nix
    ../../modules/system/common/cleanup.nix
    ../../modules/system/server/vm/vm-k3s-server-n-client.nix
  ];

  networking.hostName = "thinkcentre-1";

  # cf . https://microvm-nix.github.io/microvm.nix/simple-network.html
  systemd.network.networks."10-lan" = {
    matchConfig.Name = [
      "en*"
      "vm-*"
    ];
    networkConfig = {
      Bridge = "br0";
    };
  };

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = [ "192.168.0.210/24" ];
      Gateway = "192.168.0.1";
      DNS = [ "192.168.0.1" ];
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };

  system.stateVersion = "25.11";

  users.users.admin = {
    isNormalUser = true;
    description = "Admin User";
    extraGroups = [
      "wheel"
    ];
  };

  # cf . https://mynixos.com/nixpkgs/option/nix.settings.trusted-users
  nix.settings.trusted-users = [
    "root"
    "admin"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5l/UUW0KQzQpqN+04f4QiknEqFJhm1ehXNX61OPQIz nathanfouere@tutanota.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com" # tour
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
  ];

  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5l/UUW0KQzQpqN+04f4QiknEqFJhm1ehXNX61OPQIz nathanfouere@tutanota.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com" # tour
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
  ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "admin" = import ../../home/home-server.nix;
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  age = {
    identityPaths = [ "/home/admin/.ssh/id_ed25519" ];
  };
}
