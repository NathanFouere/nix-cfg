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
}
