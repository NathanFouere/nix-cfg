{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-sweep = {
      url = "github:jzbor/nix-sweep";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      deploy-rs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.tour = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixpkgs; };
        modules = [
          ./hosts/tour/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.agenix.nixosModules.default
          inputs.nix-sweep.nixosModules.default
          inputs.microvm.nixosModules.host
        ];
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixpkgs; };
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.agenix.nixosModules.default
          inputs.nix-sweep.nixosModules.default
        ];
      };

      nixosConfigurations.thinkcentre-1 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixpkgs; };
        modules = [
          ./hosts/thinkcentre-1/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          inputs.microvm.nixosModules.host
          inputs.nix-sweep.nixosModules.default
        ];
      };

      nixosConfigurations.thinkcentre-2 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixpkgs; };
        modules = [
          ./hosts/thinkcentre-2/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          inputs.microvm.nixosModules.host
          inputs.nix-sweep.nixosModules.default
        ];
      };

      # deploy-rs cf . https://paradigmatic.systems/posts/setting-up-deploy-rs/
      deploy = {
        nodes = {
          thinkcentre-1 = {
            hostname = "thinkcentre-1";
            profiles.system = {
              sshUser = "root";
              user = "root";
              path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.thinkcentre-1;
            };
          };
          thinkcentre-2 = {
            hostname = "thinkcentre-2";
            profiles.system = {
              sshUser = "root";
              user = "root";
              path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.thinkcentre-2;
            };
          };
        };
      };

      ## TODO => pour le moment il fait aussi les checks sur laptopt et tour, à fixer
      checks = builtins.mapAttrs (sys: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nixfmt
          inputs.agenix.packages.${system}.default
          inputs.deploy-rs.packages.${system}.default
        ];
      };
    };
}
