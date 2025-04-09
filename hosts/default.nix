{
  imports = [
    ./aurora
  ];

  nixosConfigurations = {
    apollo = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./apollo/configuration.nix
        inputs.stylix.nixosModules.stylix
        ./stylix.nix
        ../nixos
      ];
    };
    astra = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        inputs.sops-nix.nixosModules.sops
        ./astra/configuration.nix
        ../nixos
      ];
    };
  };
}
