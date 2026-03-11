{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      opencode
    ];

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [
        "glm-4.7-flash"
        "deepseek-r1:1.5b"
      ];
    };
  };
}
