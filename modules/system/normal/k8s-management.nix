{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      kubectl
      kubeseal
      k9s
    ];
  };
}
