{
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/agenix.nix
    ../../modules/system/cleanup.nix
    ../../modules/vm/config.nix
  ];

  networking.hostName = "thinkcentre-1";

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
