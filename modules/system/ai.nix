{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      opencode
    ];
  };
}
