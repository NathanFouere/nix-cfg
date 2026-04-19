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
      language_models = {
        openai_compatible = {
          "Z.ai" = {
            api_url = "https://api.z.ai/api/coding/paas/v4";
            available_models = [
              {
                name = "glm-4.6";
                display_name = "GLM-4.6";
                max_tokens = 200000;
                max_output_tokens = 128000;
                max_completion_tokens = 128000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                  prompt_cache_key = true;
                };
              }
              {
                name = "glm-4.7";
                display_name = "GLM-4.7";
                max_tokens = 200000;
                max_output_tokens = 128000;
                max_completion_tokens = 128000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                  prompt_cache_key = true;
                };
              }
              {
                name = "glm-5";
                display_name = "GLM-5";
                max_tokens = 200000;
                max_output_tokens = 128000;
                max_completion_tokens = 128000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                  prompt_cache_key = true;
                };
              }
              {
                name = "glm-5.1";
                display_name = "GLM-5.1";
                max_tokens = 200000;
                max_output_tokens = 128000;
                max_completion_tokens = 128000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                  prompt_cache_key = true;
                };
              }
            ];
          };
        };
      };
    };
  };
}
