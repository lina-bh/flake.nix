{ pkgs, lib, ... }:
{
  i18n.extraLocales = [ "en_US.UTF-8" ];

  programs.steam = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    lact
    gamescope
  ];

  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "graphical.target" ];
  };

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    autoStart = false;
  };
}
