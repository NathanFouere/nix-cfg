{
  pkgs,
  ...
}:
{
  config = {
    services = {
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
      xserver = {
        enable = true;
        xkb = {
          layout = "fr";
          variant = "azerty";
        };
      };
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    #

    environment.systemPackages = with pkgs; [
      gnomeExtensions.user-themes
      gnomeExtensions.just-perfection
      gnomeExtensions.advanced-alttab-window-switcher
      gnome-tweaks
    ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany # web browser
      simple-scan # document scanner
      yelp # help viewer
      geary # email client
      seahorse # password manager

      # these should be self explanatory
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-weather
    ];
  };
}
