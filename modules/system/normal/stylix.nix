{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [ _0xproto ];
  stylix.enable = true;
  stylix.targets.qt.enable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/embers.yaml";
  stylix.image = ../../../assets/wallpaper/dark.png;
  stylix.polarity = "dark";
  stylix.opacity = {
    desktop = 0.9;
    applications = 0.9;
    terminal = 0.9;
    popups = 0.9;
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
      package = pkgs._0xproto;
      name = "0xProto";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
