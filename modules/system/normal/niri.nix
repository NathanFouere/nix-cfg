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
