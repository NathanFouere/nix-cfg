{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Options reference: https://github.com/noctalia-dev/noctalia/blob/main/example.toml
  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        corner_radius_scale = 1.0;
        shadow.alpha = 0.6;
        panel = {
          transparency_mode = "glass";
          border_color = "primary";
          launcher_placement = "floating";
          control_center_placement = "floating";
        };
        launcher.app_grid = true;
      };

      # Floating, rounded bar detached from the screen edges
      bar.default = {
        thickness = 36;
        margin_ends = 14;
        margin_edge = 8;
        radius = 14;
        background_opacity = 0.85;
        compositor_blur = true;
        capsule = true;
        capsule_opacity = 0.6;
      };

      widget.battery = {
        show_label = true;
        label_content = "percent";
      };

      wallpaper = {
        enabled = true;
        default.path = "${config.stylix.image}";
        transition = [
          "disc"
          "honeycomb"
          "melt"
        ];
      };

      backdrop = {
        enabled = true;
        blur_intensity = 0.6;
      };

      lockscreen.blurred_desktop = true;

      notification.border_color = "primary";
      osd = {
        position = "bottom_center";
        border_color = "primary";
      };
    };
  };
}
