{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common/tailscale.nix
    ../../modules/system/common/agenix.nix
    ../../modules/system/common/cleanup.nix
  ];

  networking.hostName = "raspberry-pi3-1";

  system.stateVersion = "25.11";

  # cf . https://wiki.nixos.org/wiki/Swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192; # 8 GiB
    }
  ];

  users.users.admin = {
    isNormalUser = true;
    description = "Admin User";
    extraGroups = [
      "wheel"
    ];
  };

  # cf . https://citizen428.net/blog/installing-nixos-raspberry-pi-3/

  # Disable GRUB
  boot.loader.grub.enable = false;

  boot.loader.generic-extlinux-compatible.enable = true;

  # A bunch of boot parameters needed for optimal runtime on RPi 3b+
  environment.systemPackages = with pkgs; [

  ];
  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;

  # Configure basic SSH access
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # cf . https://mynixos.com/nixpkgs/option/nix.settings.trusted-users
  nix.settings.trusted-users = [
    "root"
    "admin"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5l/UUW0KQzQpqN+04f4QiknEqFJhm1ehXNX61OPQIz nathanfouere@tutanota.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com" # tour
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com" # thinkcentre-1
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
  ];

  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5l/UUW0KQzQpqN+04f4QiknEqFJhm1ehXNX61OPQIz nathanfouere@tutanota.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLqKehCp63zveXLYnz+r/3E/orptsNliJfccxejvnlp nathanfouere@tutanota.com" # tour
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com" # thinkcentre-1
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
  ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "admin" = import ../../home/home-server.nix;
    };
  };

  age = {
    identityPaths = [ "/home/nixos/.ssh/id_ed25519" ];
  };
}
