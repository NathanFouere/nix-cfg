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
