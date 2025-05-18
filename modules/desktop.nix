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
    binfmt.emulatedSystems = [ "aarch64-linux" ];
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
      greetd.fprintAuth = false;
      login.fprintAuth = false;
      sudo.fprintAuth = false;
      kde.fprintAuth = false;

      greetd.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
    };
  };

  time.timeZone = "Europe/London";
  i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";

  services.desktopManager.plasma6.enable = true;
  programs.kde-pim.enable = false;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      ark
      elisa
      gwenview
      okular
      kate
      krdp
    ];
    systemPackages =
      (with pkgs; [
        solaar
        man-pages
        resources
        shellcheck
        (devcontainer.override {
          docker = null;
          docker-compose = null;
        })
      ])
      ++ (with pkgs.kdePackages; [
        ksshaskpass
        plasma-disks
        filelight
        kdeconnect-kde
      ]);
  };

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

  documentation = {
    man.generateCaches = true;
    nixos.enable = true;
    doc.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      gyre-fonts
      liberation_ttf
      inter
      jetbrains-mono
      iosevka
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      unifont
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
    sysprof.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session.command = "${config.services.greetd.package}/bin/agreety -c ${lib.getExe config.users.users.lina.shell}";
        initial_session = {
          command =
            with pkgs.kdePackages;
            "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${plasma-workspace}/bin/startplasma-wayland";
          user = "lina";
        };
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    sensor.iio.enable = false;
  };

  programs = {
    adb.enable = true;
  };
}
