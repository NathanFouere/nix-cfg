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
        # completer avec https://microvm-nix.github.io/microvm.nix/options.html
        my-microvm = {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          config = {
            microvm.shares = [{
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }];
          };
        };
      };
  };
}
