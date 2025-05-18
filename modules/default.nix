{ home-manager, ... }:
{
  common = ./common.nix;
  desktop = ./desktop.nix;
  development = ./development.nix;
  games = ./games.nix;
  scx_loader = ./scx_loader.nix;
  user = {
    imports = [ home-manager.nixosModules.home-manager ];
    home-manager = {
      # useUserPackages = true;
      useGlobalPkgs = true;
    };
  } // import ./user.nix;
}
