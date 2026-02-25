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
      loadModels = [ "glm-4.7-flash" "deepseek-r1:1.5b"];
    };
  };
}
