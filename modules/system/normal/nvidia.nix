{
  config,
  pkgs,
  ...
}:
{
  config = {
    ## Config copied from https://github.com/Arroquw/nixos-config/blob/main/modules/nixos/nvidia/default.nix
    nixpkgs.config.nvidia.acceptLicense = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true; # Disable if issues with sleep/suspend
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        nvidiaSettings = true;
        open = true;
      };
      graphics = {
        #driSupport = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    };

  };
}
