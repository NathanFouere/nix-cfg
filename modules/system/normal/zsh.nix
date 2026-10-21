{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      zsh
      fastfetch
    ];

    programs = {
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        ohMyZsh = {
          enable = true;
          # Prompt handled by starship
          theme = "";
          plugins = [
            "git"
            "kubectl"
            "helm"
            "docker"
          ];
        };
      };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          format = "$directory$git_branch$git_status$nix_shell$kubernetes$cmd_duration$line_break$character";
          character = {
            success_symbol = "[❯](bold purple)";
            error_symbol = "[❯](bold red)";
          };
          directory = {
            style = "bold cyan";
            truncation_length = 3;
            truncate_to_repo = true;
          };
          git_branch = {
            symbol = "⎇ ";
            style = "bold purple";
          };
          git_status.style = "bold yellow";
          nix_shell = {
            symbol = "❄ ";
            format = "[$symbol$name]($style) ";
          };
          kubernetes = {
            disabled = false;
            symbol = "☸ ";
            format = "[$symbol$context]($style) ";
          };
          cmd_duration = {
            min_time = 2000;
            format = "[⏱ $duration]($style) ";
          };
        };
      };

      # Charge automatiquement le devShell d'un projet contenant un .envrc (`use flake`)
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    users.defaultUserShell = pkgs.zsh;
  };
}
