{
  pkgs,
  ...
}:
{
  config = {
    # cf .https://nixos.wiki/wiki/NFS

    fileSystems."/export/nfs-share" = {
      device = "/mnt/nas/services";
      fsType = "none";
      options = [ "bind" ];
    };

    services.nfs.server.enable = true;
    # cf . https://man7.org/linux/man-pages/man5/exports.5.html
    # cf . https://aws.amazon.com/fr/what-is/cidr/
    services.nfs.server.exports = ''
      /export/nfs-share  192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)
    '';

    networking.firewall.allowedTCPPorts = [ 2049 ];
  };
}
