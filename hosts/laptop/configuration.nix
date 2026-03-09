{
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common/base.nix
    ../../modules/system/normal/base-perso.nix
    ../../modules/system/normal/stylix.nix
    ../../modules/system/normal/zsh.nix
    ../../modules/system/normal/gnome.nix
    ../../modules/system/normal/docker.nix
    ../../modules/system/normal/vial.nix
    ../../modules/system/normal/nvidia.nix
    ../../modules/system/common/agenix.nix
    ../../modules/system/common/cleanup.nix
    ../../modules/system/normal/ai-host.nix
    ../../modules/system/normal/streaming-torrent.nix
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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com" # thinkcentre-1
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
