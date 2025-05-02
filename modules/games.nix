{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

  i18n.extraLocales = [ "en_US.UTF-8" ];

  programs.steam = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
