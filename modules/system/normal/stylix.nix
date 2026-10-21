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
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/embers.yaml";
  stylix.override = {
    base00 = "0b0907";
    base01 = "171410";
    base02 = "2c2620";
  };
  stylix.image = ../../../assets/wallpaper/promethee_4k.jpg;
  stylix.polarity = "dark";
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 22;
  };
  stylix.opacity = {
    desktop = 0.9;
    applications = 0.93;
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
