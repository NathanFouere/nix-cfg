{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      discord
      vesktop
      steam
      signal-desktop
      postman
      obs-studio
      proton-vpn
      rpi-imager
    ];
  };
}
