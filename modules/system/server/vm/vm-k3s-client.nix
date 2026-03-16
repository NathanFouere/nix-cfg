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

  # SSH key for these VMs (thinkcentre-2)
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVoTuoNCuqpEVk8q9aRP3XAKrcRjuKOddlW6Te3hokC nathanfouere@tutanota.com";

  subnet  = "192.168.1";

  gateway = "${subnet}.1";

  dns     = "${subnet}.1";

  serverAddr = "https://${subnet}.211:6443";
in
{
  config = {
    # cf . https://microvm-nix.github.io/microvm.nix/host-options.html
    microvm.host.enable = true;
    microvm.autostart = [
      "vm-k3s-c-2"
      "vm-k3s-c-3"
    ];
    microvm.vms = {
      vm-k3s-c-2 = k3sVM {
        inherit
          config
          inputs
          nixpkgs
          pkgs
          ;
        name = "vm-k3s-c-2";
        ip = "${subnet}.221";
        mac = "02:00:00:00:00:03";
        cid = 3;
        role = "agent";
        inherit gateway;
        inherit dns;
        inherit sshKey;
        inherit serverAddr;
      };
      vm-k3s-c-3 = k3sVM {
        inherit
          config
          inputs
          nixpkgs
          pkgs
          ;
        name = "vm-k3s-c-3";
        ip = "${subnet}.222";
        mac = "02:00:00:00:00:04";
        cid = 4;
        role = "agent";
        inherit gateway;
        inherit dns;
        inherit sshKey;
        inherit serverAddr;
      };
    };
  };
}
