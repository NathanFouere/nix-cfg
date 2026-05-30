{
  pkgs,
  ...
}:
{
  config = {
    virtualisation = {
      docker.enable = true;
      containerd.enable = true;
      cri-o.enable = true;
    };

    environment.systemPackages = with pkgs; [
      lazydocker
      cri-tools
    ];
  };
}
