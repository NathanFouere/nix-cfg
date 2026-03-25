{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      kubectl
      k9s
    ];
  };
}
