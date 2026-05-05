{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common/tailscale.nix
    ../../modules/system/common/base.nix
    ../../modules/system/server/base-server.nix
    ../../modules/system/common/agenix.nix
    ../../modules/system/common/cleanup.nix
  ];

  networking.hostName = "raspberry-pi3-1";

  system.stateVersion = "25.11";

  users.users.admin = {
    isNormalUser = true;
    description = "Admin User";
    extraGroups = [
      "wheel"
    ];
  };

  # cf . https://citizen428.net/blog/installing-nixos-raspberry-pi-3/

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;

  # Use the generic extlinux bootloader (replacement for removed raspberryPi loader)
  boot.loader.generic-extlinux-compatible.enable = true;

  # if you have a Raspberry Pi 2 or 3, pick this:
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # A bunch of boot parameters needed for optimal runtime on RPi 3b+
  boot.kernelParams = ["cma=256M"];
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.cleanTmpDir = true;

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
      size = 4 * 1024; # 4GB
    }
  ];

  age = {
    identityPaths = [ "/home/admin/.ssh/id_ed25519" ];
  };
}
