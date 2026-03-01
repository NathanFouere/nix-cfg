{
  config,
  nixpkgs,
  pkgs,
  microvm,
  ...
}:
{
  config = {
    microvm.vms = {
      # cf . https://microvm-nix.github.io/microvm.nix/options.html
      vm-one = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        autostart = true;
        restartIfChanged = true;
        config = {
          microvm.hypervisor = "qemu";
          microvm.vcpu = 2;
          microvm.mem = 1024;
          microvm.interfaces = [
            {
              type = "user";
              id = "vm-1";
              mac = "02:00:00:00:00:01";
            }
          ];
          #cf . https://microvm-nix.github.io/microvm.nix/shares.html
          microvm.shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
            }
          ];
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
          microvm.hypervisor = "qemu";
          microvm.vcpu = 2;
          microvm.mem = 1024;
          microvm.interfaces = [
            {
              type = "user";
              id = "vm-2";
              mac = "02:00:00:00:00:02";
            }
          ];
          #cf . https://microvm-nix.github.io/microvm.nix/shares.html
          microvm.shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
            }
          ];
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
