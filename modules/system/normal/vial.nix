{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
      vial
    ];

    # cf . https://www.reddit.com/r/olkb/comments/ydf353/qmk_on_nixos_cant_see_keyboard_ferris_sweep/
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="0000", OWNER="1000", GROUP="100", MODE="0666"
    '';
  };
}
