{
  inputs,
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = [
      inputs.deploy-rs.packages.${pkgs.system}.default
    ];
  };
}
