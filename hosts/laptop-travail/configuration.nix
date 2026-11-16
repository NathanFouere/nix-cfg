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
    ../../modules/system/normal/bluetooth.nix
    ../../modules/system/normal/virtualisation.nix
    ../../modules/system/normal/vial.nix
    ../../modules/system/common/cleanup.nix
    ../../modules/system/common/open-ssh.nix
    ../../modules/system/normal/prog.nix
    ../../modules/system/normal/niri.nix
    ../../modules/system/normal/calendar.nix
    ../../modules/system/normal/calendar-zimbra.nix
    ../../modules/system/normal/openconnect.nix
    ../../modules/system/common/github-cli.nix
    ../../modules/system/common/ssh-client.nix
    ../../modules/system/common/tailscale.nix
    ../../modules/system/normal/k8s-management.nix
  ];

  networking.hostName = "laptop-travail";
  custom.ssh.bastionIp = "100.90.231.15";

  age.secrets.tailscale-oauth-id.file = ../../secrets/tailscale-oauth-id.age;
  age.secrets.tailscale-oauth-key.file = ../../secrets/tailscale-oauth-key.age;
  system.stateVersion = "26.11";

  services.upower.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/W4/ioRVmnittNFSscL1GdZF7qFy2RtaizNvcHjFZO nathanfouere@tutanota.com" # laptop
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
