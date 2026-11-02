{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
  ];

  # https://github.com/Satty-org/Satty
  programs.satty = {
    enable = true;

    settings = {
      general = {
        fullscreen = true;
        early-exit = true;
        copy-command = "wl-copy";
        save-after-copy = false;
        initial-tool = "arrow";
        output-filename = "~/Pictures/Screenshots/satty-%Y-%m-%d_%H-%M-%S.png";
      };
    };
  };
}
