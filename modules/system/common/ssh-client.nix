{
  ...
}:
{
  # Config SSH client pour se connecter aux machines via le bastion
  programs.ssh = {
    extraConfig = "
      Host bastion
        Hostname 192.168.1.23
        Port 22
        User jumpadmin
        IdentityFile ~/.ssh/id_ed25519
        
      Host thinkcentre-1
        Hostname 192.168.1.210
        User admin
        ProxyJump bastion

      Host thinkcentre-2
        Hostname 192.168.1.220
        User admin
        ProxyJump bastion
    ";
  };
}
