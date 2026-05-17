{
  config,
  pkgs,
  ...
}:
{
  config = {
    # cf . https://mynixos.com/nixpkgs/options/services.openssh
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = "prohibit-password";
  };
}
