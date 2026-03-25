{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      fluxcd
      helm
    ];
  };
}
