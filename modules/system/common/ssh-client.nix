{ config, lib, ... }:

{
  options.custom.ssh.bastionIp = lib.mkOption {
    type = lib.types.str;
    description = "Bastion IP address";
  };

  options.custom.ssh.useProxyJump = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to use ProxyJump through the bastion";
  };

  config = {
    programs.ssh = {
      extraConfig = "
        Host bastion
          Hostname ${config.custom.ssh.bastionIp}
          Port 22
          User jumpadmin
          IdentityFile ~/.ssh/id_ed25519

        Host thinkcentre-1
          Hostname 192.168.1.210
          User admin
          ${lib.optionalString config.custom.ssh.useProxyJump "ProxyJump bastion"}

        Host thinkcentre-2
          Hostname 192.168.1.220
          User admin
          ${lib.optionalString config.custom.ssh.useProxyJump "ProxyJump bastion"}
      ";
    };
  };
}
