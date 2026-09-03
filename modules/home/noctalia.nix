{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      shell.corner_radius_scale = 0;

      bar.default = {
        margin_ends = 0;
        radius = 0;
      };

      wallpaper = {
        enabled = true;
        default.path = "${config.stylix.image}";
      };

      backdrop = {
        enabled = true;
      };
    };
  };
}
