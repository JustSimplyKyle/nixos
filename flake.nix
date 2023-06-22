{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    xdg-desktop-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    ironbar.url = "github:JakeStanger/ironbar";
    webcord.url = "github:fufexan/webcord-flake";
    anyrun.url = "github:Kirottu/anyrun";
  };

  outputs = inputs@{nixpkgs, home-manager, hyprland, ...}: 
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          hyprland.nixosModules.default {
            programs.hyprland.enable = true;
          }
          home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = false;
              extraSpecialArgs = { inherit inputs;};
              users.kyle = ./home/home.nix;
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}

