{
  pkgs,
  ...
}:
{
  # Connexion : sudo openconnect --protocol=anyconnect --useragent=AnyConnect <gateway>
  environment.systemPackages = [ pkgs.openconnect ];
}
