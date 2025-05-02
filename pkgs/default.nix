{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
flake-utils.lib.eachDefaultSystemPassThrough (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    "${system}" = {
      eduroam-linux-UoG = pkgs.callPackage self.lib.mk-eduroam-cat {
        profile = 574;
        university = "UoG";
        hash = "sha256-28MQsSGBiWVDfBh8x4QncegU1KURHLfeW7cumZqth1g=";
      };
    };
  }
)
