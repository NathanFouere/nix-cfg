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
      telegram-desktop
      element-desktop
      signal-desktop
      postman
      obs-studio
      proton-vpn
      rpi-imager
    ];
  };
}
