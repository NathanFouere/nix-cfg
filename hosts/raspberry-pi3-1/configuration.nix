{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "raspberry-pi3-1";

  system.stateVersion = "25.11";

  # cf . https://wiki.nixos.org/wiki/Swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8192;  # 8 GiB
  }];

  # cf . https://citizen428.net/blog/installing-nixos-raspberry-pi-3/

  # Disable GRUB
  boot.loader.grub.enable = false;

  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;

}
