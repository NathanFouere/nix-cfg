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
    };

    users.defaultUserShell = pkgs.zsh;
  };
}
