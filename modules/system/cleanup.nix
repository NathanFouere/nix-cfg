{
  ...
}:
{
  services.nix-sweep = {
    enable = true;
    interval = "daily";
    removeOlder = "7d";
    keepMin = 10;
    gc = true;
    gcInterval = "daily";
  };
}
