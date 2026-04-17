{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      kubernetes-helm
      fluxcd
      git
      kubectl
      k9s
      kubeseal
      fluxcd-operator
    ];
  };
}
