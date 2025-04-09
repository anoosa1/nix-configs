{
  nixosConfigurations = {
    aurora = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        inputs.stylix.nixosModules.stylix
        ./configuration.nix
        .../stylix.nix
        .../nixos
      ];
    };
  };
}
