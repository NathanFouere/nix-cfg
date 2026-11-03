{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.proton-vpn.file = ../../../secrets/proton-vpn.age;

  networking.wg-quick.interfaces.proton = {
    configFile = config.age.secrets.proton-vpn.path;
    autostart = true;
  };

  # Si wg-quick démarre après tailscale, ses règles passent devant celles de tailscale : on remet le tailnet (table 52)
  # et le trafic chiffré de tailscaled (fwmark 0x80000) devant, pour qu'ils ne partent pas dans le tunnel Proton
  systemd.services.wg-quick-proton = lib.mkIf config.services.tailscale.enable {
    path = [ pkgs.iproute2 ];
    postStart = ''
      ip rule add to 100.64.0.0/10 lookup 52 priority 5000 || true
      ip rule add fwmark 0x80000/0xff0000 lookup main priority 5001 || true
    '';
    preStop = ''
      ip rule del priority 5000 || true
      ip rule del priority 5001 || true
    '';
  };
}
