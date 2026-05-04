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
        "glm-5:cloud"
        "glm-5.1:cloud"
      ];
    };
  };
}
