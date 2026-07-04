{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    _0xproto
    bibata-cursors
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  stylix.enable = true;
  stylix.targets.qt.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-light.yaml";
  stylix.image = ../../../assets/wallpaper/light.png;
  stylix.polarity = "light";
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };
  stylix.opacity = {
    desktop = 0.9;
    applications = 0.95;
    terminal = 0.85;
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
      package = pkgs._0xproto;
      name = "0xProto";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
