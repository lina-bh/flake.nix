{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    consoleLogLevel = 2;
    initrd.verbose = false;
    kernelParams = [ "kvm.enable_virt_at_load=0" ];
  };

  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [ ];
  };
  networking.modemmanager.enable = false;
  powerManagement.enable = true;

  security = {
    rtkit.enable = true;
    pam.services = {
      login.fprintAuth = false;
      sudo.fprintAuth = false;
      kde.fprintAuth = false;
    };
  };

  time.timeZone = "Europe/London";
  i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.kde-pim.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark
    elisa
    gwenview
    okular
    kate
    krdp
  ];

  environment.systemPackages =
    (with pkgs; [
      aria2
      ffmpeg
      pv
      resources
      smartmontools
      solaar
      sysfsutils
      toolbox
    ])
    ++ (with pkgs.kdePackages; [
      ksshaskpass
      plasma-disks
      filelight
      kdeconnect-kde
    ]);

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} =
    let
      kdeconnect = {
        from = 1714;
        to = 1764;
      };
    in
    {
      allowedUDPPortRanges = [ kdeconnect ];
      allowedTCPPortRanges = [ kdeconnect ];
    };

  documentation.man.generateCaches = true;

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      dejavu_fonts
      gyre-fonts
      liberation_ttf
      inter
      jetbrains-mono
      iosevka
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
    ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    udev = {
      packages = [ pkgs.solaar ];
    };
  };

  hardware = {
    bluetooth.enable = true;
    sensor.iio.enable = false;
  };
}
