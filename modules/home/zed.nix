{
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
      "cpp"
      "php"
      "html"
      "js"
      "catppuccin-icons"
      "copilot"
      "base16"
    ];
    userSettings = {
      hour_format = "hour24";
      vim_mode = false;
      show_edit_predictions = true;
      show_completions_on_input = true;
      scrollbar = {
        show = "never";
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      inlay_hints = {
        enabled = true;
      };
      project_panel = {
        button = true;
        dock = "right";
        git_status = true;
      };
      centered_layout = {
        left_padding = 0.15;
        right_padding = 0.15;
      };
      assistant = {
        enabled = true;
        provider = "copilot";
      };
    };
  };
}
