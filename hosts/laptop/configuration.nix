{
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/base-perso.nix
    ../../modules/system/stylix.nix
    ../../modules/system/zsh.nix
    ../../modules/system/gnome.nix
    ../../modules/system/docker.nix
    ../../modules/system/vial.nix
    ../../modules/system/agenix.nix
    ../../modules/system/cleanup.nix
    ../../modules/system/ai.nix
  ];

  networking.hostName = "laptop";

  system.stateVersion = "24.11";

  users.users.nathanf = {
    isNormalUser = true;
    description = "Nathan Fouéré";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
    ];
  };

  users.users.nathanf.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com" # tour
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGt1eMrTeYJ+cG9LkLotYKvRpeWwNEjq1HF+XjZUdQ1 nathanfouere@tutanota.com" # thinkcentre-1
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
  ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nathanf" = import ../../home/home-perso.nix;
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  age = {
    identityPaths = [ "/home/nathanf/.ssh/id_ed25519" ];
  };
}
