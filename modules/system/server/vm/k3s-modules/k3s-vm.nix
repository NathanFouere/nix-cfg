{
  config,
  pkgs,
  nixpkgs,
  ...
}:
# Helper function to create a k3s VM with common configuration
{
  # Function parameters
  name,
  ip,
  mac,
  cid,
  role ? "agent",
  sshKey,
  serverAddr ? "https://192.168.0.211:6443",
}:
{
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  restartIfChanged = true;

  imports = [
    ./base.nix
    (if role == "server" then ./server.nix else ./agent.nix)
  ];

  config = {
    microvm.volumes = [
      {
        image = "/var/lib/microvms/${name}/disk.img";
        mountPoint = "/var/lib/k3s";
        autoCreate = true;
        size = 30 * 1024; # 30GB
      }
    ];

    microvm.interfaces = [
      {
        type = "tap";
        id = name;
        inherit mac;
      }
    ];

    microvm.vsock.cid = cid;

    networking.hostName = name;

    systemd.network.networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "${ip}/24" ];
        Gateway = "192.168.0.1";
        DNS = [ "192.168.0.1" ];
        DHCP = "no";
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [ sshKey ];
  };
}
