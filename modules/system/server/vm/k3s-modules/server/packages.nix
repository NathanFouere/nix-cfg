{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      kubernetes-helm
      fluxcd
      kubectl
      k9s
      kubeseal
      fluxcd-operator
    ];
  };
}
