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
          theme = "robbyrussell";
          plugins = [
            "git"
            "kubectl"
            "helm"
            "docker"
          ];
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
