{
  pkgs,
  ...
}:
{
  config = {

    # Enable sound with pipewire.
    services.pulseaudio = {
      enable = false;
    };
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.firefox = {
      enable = true;
      policies = {
        ImportEnterpriseRoots = true;
      };
    };

    environment.systemPackages = with pkgs; [
      obsidian
      vscode
      discord
      wasistlos
      telegram-desktop
      vesktop
      qbittorrent
      gimp
      chromium
      postman
      steam
      libreoffice
      vlc
      element-desktop
      obs-studio
    ];

    # cf . https://nixos.wiki/wiki/Firewall
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 4444 ]; # temporaire
    };
  };
}
