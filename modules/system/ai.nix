{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      ollama
      opencode
    ];

    services.ollama = {
      enable = true;
    };
  };
}
