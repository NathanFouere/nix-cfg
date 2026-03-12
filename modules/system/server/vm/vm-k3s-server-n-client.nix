{
  config,
  inputs,
  nixpkgs,
  pkgs,
  microvm,
  ...
}:
let
  # Import the k3s-vm helper function
  k3sVM = import ./k3s-modules/k3s-vm.nix;

  # SSH key for these VMs (thinkcentre-1)
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjeepX6RNKZ7s6HOy3yGlSF+EUDztviuL+iTgFxZQOl nathanfouere@tutanota.com";
in
{
  config = {
    # cf . https://microvm-nix.github.io/microvm.nix/host-options.html
    microvm.host.enable = true;
    microvm.autostart = [
      "vm-k3s-s"
      "vm-k3s-c-1"
    ];
    microvm.vms = {
      vm-k3s-s = k3sVM {
        inherit
          config
          inputs
          nixpkgs
          pkgs
          ;
        name = "vm-k3s-s";
        ip = "192.168.0.211";
        mac = "02:00:00:00:00:01";
        cid = 3;
        role = "server";
        inherit sshKey;
      };
      vm-k3s-c-1 = k3sVM {
        inherit
          config
          inputs
          nixpkgs
          pkgs
          ;
        name = "vm-k3s-c-1";
        ip = "192.168.0.212";
        mac = "02:00:00:00:00:02";
        cid = 4;
        role = "agent";
        inherit sshKey;
      };
    };
  };
}
