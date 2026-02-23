{
  config,
  pkgs,
  ...
}:
{
  config = {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # cf . https://mynixos.com/nixpkgs/options/services.openssh
    services.openssh = {
      enable = true;
    };

    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
    };

    # Configure console keymap
    console.keyMap = "en";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      nix-sweep
    ];
  };
}
