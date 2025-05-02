{ self, nixpkgs, ... }@inputs:
{
  framework = nixpkgs.lib.nixosSystem (import ./framework inputs);
}
