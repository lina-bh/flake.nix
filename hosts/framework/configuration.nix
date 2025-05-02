{
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
      systemd-boot.enable = true;
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
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [
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
    displayManager.autoLogin = {
      enable = true;
      user = "lina";
    };
    scx = {
      package = lib.mkDefault pkgs.scx.rustscheds;
      loader = {
        enable = true;
        config = {
          default_sched = "scx_bpfland";
        };
      };
    };
  };

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "24.11";
}
