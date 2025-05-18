{
  self,
  nixos-hardware,
  chaotic,
  ...
}:
let
  chaoticPkgs = chaotic.legacyPackages.x86_64-linux;
  nixosModules.gamescope_git = {
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
  };
  nixosModules.cachyos_kernel = {
    boot.kernelPackages = chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos;
  };
  nixosModules.mesa_git = {
    hardware.graphics = {
      package = chaoticPkgs.mesa_git;
      package32 = chaoticPkgs.mesa32_git;
    };
  };
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
    self.nixosModules.user
    ./configuration.nix
    nixosModules.mesa_git
  ];
}
