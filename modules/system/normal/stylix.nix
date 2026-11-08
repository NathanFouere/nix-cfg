{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    _0xproto
    nerd-fonts._0xproto
    bibata-cursors
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  stylix.enable = true;
  stylix.targets.qt.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/embers-light.yaml";
  stylix.image = ../../../assets/wallpaper/background-2.png;
  stylix.polarity = "light";
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };
  stylix.opacity = {
    desktop = 0.94;
    applications = 0.95;
    # Window transparency is applied uniformly by niri (applications opacity)
    terminal = 1.0;
    popups = 1.0;
  };
  stylix.fonts = {
    serif = {
      package = pkgs._0xproto;
      name = "0xProto";
    };

    sansSerif = {
      package = pkgs._0xproto;
      name = "0xProto";
    };

    monospace = {
      package = pkgs.nerd-fonts._0xproto;
      name = "0xProto Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
