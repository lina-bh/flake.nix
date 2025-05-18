{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  networking.hostName = "framework";
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = [ pkgs.sof-firmware ];
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "bluetooth.disable_ertm=1"
      "amdgpu.dcdebugmask=0x410"
    ];
    blacklistedKernelModules = [
      "amdxdna"
    ];
    initrd = {
      # systemd.enable = null;
      luks.devices."crypt".device = "/dev/disk/by-uuid/bbf40d28-ade8-4213-b342-bf669ec23e75";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "noatime"
        "lazytime"
        "compress-force=zstd:1"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [
        "nodev"
        "noexec"
        "noatime"
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  services = {
    hardware.bolt.enable = true;
    fwupd.enable = true;
    scx = {
      package = lib.mkDefault pkgs.scx.rustscheds;
      loader = {
        enable = true;
        config = {
          default_sched = "scx_lavd";
        };
      };
    };
  };

  environment = {
    variables.KWIN_FORCE_ASSUME_HDR_SUPPORT = "1";
  };

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "24.11";
  home-manager.users.lina.home.stateVersion = "24.11";
}
