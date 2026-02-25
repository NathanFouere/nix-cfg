{
  pkgs,
  config,
  ...
}:
{
  config = {
    services.deluge = {
       enable = true;
       web.enable = true;
    };

    services.radarr = {
      enable = true;
      openFirewall = true;
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
