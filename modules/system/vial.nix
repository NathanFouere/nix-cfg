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
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess", TAG+="udev-acl", GROUP="nathanf"
    '';
  };
}
