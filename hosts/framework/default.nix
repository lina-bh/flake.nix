{
  self,
  nixos-hardware,
  chaotic,
  ...
}:
let
  nixosModules.gamescope_git = (
    let
      chaoticPkgs = chaotic.legacyPackages.x86_64-linux;
    in
    {
      environment.systemPackages = [
        chaoticPkgs.gamescope_git
      ];
      hardware.graphics = {
        extraPackages = [
          chaoticPkgs.gamescope-wsi_git
        ];
        extraPackages32 = [
          chaoticPkgs.gamescope-wsi32_git
        ];
      };
    }
  );
in
{
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.framework-13-7040-amd
    self.nixosModules.scx_loader
    self.nixosModules.common
    self.nixosModules.desktop
    self.nixosModules.games
    self.nixosModules.development
    ./configuration.nix
    nixosModules.gamescope_git
  ];
}
