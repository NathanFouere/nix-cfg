{
  config,
  nixpkgs,
  pkgs,
  microvm,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      qemu
    ];

    microvm.vms = {
      # cf . https://microvm-nix.github.io/microvm.nix/options.html
      vm-one = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        autostart = true;
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "cloud-hypervisor";
          microvm.vcpu = 2;
          microvm.mem = 1024;
          environment.systemPackages = with pkgs; [
            htop
          ];
          services.getty.autologinUser = "root";
          system.stateVersion = "25.11";
        };
      };
      vm-two = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        autostart = true;
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "cloud-hypervisor";
          microvm.vcpu = 2;
          microvm.mem = 1024;
          environment.systemPackages = with pkgs; [
            htop
          ];
          services.getty.autologinUser = "root";
          system.stateVersion = "25.11";
        };
      };
    };
  };
}
