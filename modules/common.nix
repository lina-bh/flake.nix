{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.supportedFilesystems.xfs = true;

  i18n.defaultLocale = "C.UTF-8";

  zramSwap.enable = true;

  hardware.firmware = [ pkgs.linux-firmware ];

  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-trusted-users = [ "@wheel" ];
      cores = 1;
      max-jobs = 2;
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables.EDITOR = "vi";
    systemPackages = with pkgs; [
      config.boot.kernelPackages.perf
      fd
      file
      git
      gnumake
      hdparm
      htop
      ldns
      libarchive
      neovim-unwrapped
      nixfmt-rfc-style
      nvme-cli
      pv
      python3
      ripgrep
      smartmontools
      sysfsutils
      unzip
    ];
  };

  programs = {
    nano.enable = false;
    command-not-found.enable = false;
    nix-ld.enable = true;
  };

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    dbus.implementation = "broker";
  };

  documentation = {
    nixos.enable = lib.mkDefault false;
    doc.enable = lib.mkDefault false;
    info.enable = false;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  systemd.user.units."podman-user-wait-network-online.service".enable = false;

  systemd.tmpfiles.rules = [
    "r /root/.nix-defexpr/channels"
    "R /nix/var/nix/profiles/per-user/root/channels"
  ];

  system.rebuild.enableNg = true;

  users.users.lina = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "vboxusers"
      "docker"
      "adbusers"
    ];
  };

  home-manager.users.lina =
    { pkgs, ... }:
    {
      programs = {
        bun.enable = true;
        bun.enableGitIntegration = false;
        uv.enable = true;
      };

      home.packages = with pkgs; [
        rustup
        distrobox
      ];
    };
}
