{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      enableOnBoot = false;
    };
  };

  home-manager.users.lina =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        direnv
        pandoc
        nil
        nix-tree
        nixd
        rustup
      ];
    };
}
