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
      cores = 0;
      max-jobs = 1;
      auto-optimise-store = true;
    };
  };

  users.users.lina = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "vboxusers"
    ];
  };

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      neovim-unwrapped
      fish
      git
      htop
      unzip
      libarchive
      file
      fd
      ripgrep
      ldns
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
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
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
}
