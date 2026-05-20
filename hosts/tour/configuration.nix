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
    ../../modules/system/normal/deploy.nix
    ../../modules/system/normal/k8s-management.nix
    ../../modules/system/normal/prog.nix
    ../../modules/system/common/ssh-client.nix
  ];

  networking.hostName = "tour";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/W4/ioRVmnittNFSscL1GdZF7qFy2RtaizNvcHjFZO nathanfouere@tutanota.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGt1eMrTeYJ+cG9LkLotYKvRpeWwNEjq1HF+XjZUdQ1 nathanfouere@tutanota.com" # thinkcentre-1
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com" # thinkcentre-2
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6+xOLTc6bWDHw9jq9TXA1Sbp29Q23n5J8dUA+A7iMQ nathanfouere@tutanota.com" # raspberry-pi3-1
  ];

  # Allow building aarch64-linux (ARM)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
