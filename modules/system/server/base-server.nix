{
  pkgs,
  ...
}:
{
  config = {
    # Enable networking
    # Pour voir la différence entre NetworkManager et systemd-networkd se référer à https://markaicode.com/ubuntu-networking-comparison/
    systemd.network.enable = true;
    networking.useNetworkd = true;
    networking.useDHCP = false;

    environment.systemPackages = with pkgs; [
      cloud-hypervisor
      iproute2
    ];
  };
}
