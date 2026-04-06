{
  ...
}:

{
  # cf . https://nohup.no/zed-editor/
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
      "mermaid"
    ];
    userSettings = {
      hour_format = "hour24";
      vim_mode = false;
      show_edit_predictions = true;
      show_completions_on_input = true;
      scrollbar = {
        show = "always";
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
        dock = "left";
        git_status = true;
      };
      centered_layout = {
        left_padding = 0.10;
        right_padding = 0.10;
      };
      format_on_save = "off";
      assistant = {
        enabled = true;
        provider = "copilot";
      };
      env = {
        TERM = "ghostty";
      };
    };
  };
}
