{ pkgs, config, ... }:
let
  devcontainer = pkgs.devcontainer.override {
    docker = pkgs.podman;
    docker-compose = null;
  };
in
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages =
    (with pkgs; [
      config.boot.kernelPackages.perf
      direnv
      rustup
      gnumake
      man-pages
      nixfmt-rfc-style
      stylua
      jujutsu
      shellcheck
      neovim-unwrapped.lua
    ])
    ++ [
      devcontainer
    ];

  # documentation.dev.enable = true;
}
