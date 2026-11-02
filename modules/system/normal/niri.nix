{
  pkgs,
  ...
}:

{
  config = {
    programs.niri = {
      enable = true;
      # niri from nixpkgs, cached on cache.nixos.org.
      package = pkgs.niri;
    };

    # We don't use the niri-flake binary cache since we use the nixpkgs package
    niri-flake.cache.enable = false;

    # Stylix (qt target) exports QT_STYLE_OVERRIDE=kvantum: the KDE polkit agent then crashes when opening
    # its QML password dialog (module "kvantum" is not installed), and every polkit request ends as "not authorized"
    systemd.user.services.niri-flake-polkit.environment.QT_STYLE_OVERRIDE = "";

    services = {
      # Trash, network shares and removable drives in nautilus (enabled by GNOME, not by niri)
      gvfs.enable = true;

      displayManager = {
        gdm = {
          enable = true;
        };
        defaultSession = "niri";
      };
      xserver = {
        enable = true;
        xkb = {
          layout = "fr";
          variant = "azerty";
        };
      };
    };

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
