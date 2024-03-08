# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, ...
}:
let
  pioRules = pkgs.stdenv.mkDerivation {
    name = "platformio-udev-rules";
    src = ./rules/.;
    dontBuild = true;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp 99-platformio-udev.rules $out/lib/udev/rules.d
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    # ./modules/wifi-resume.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # network settings
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "acpi.no_ec_wakeup=1" "acpi_osi=\"windows 2020\"" "mem_sleep_default=deep" "resume=LABEL=swap" ];
  #
  swapDevices = [{ label = "swap"; }];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # from https://www.worldofbs.com/nixos-framework/
  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "poweroff";
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h 
    SuspendState=mem
  '';

  users.users = {
    steven = {
      isNormalUser = true;
      description = "steven";
      extraGroups = [ "plugdev" "libvirtd" "docker" "dialout" "networkmanager" "wheel" "input" ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # fwupd for framework laptop
  services.fwupd.enable = true;

  # fix framework power draw bug
  # from https://github.com/NixOS/nixos-hardware/tree/master/framework/13-inch/7040-amd
  # hardware.framework.amd-7040.preventWakeOnAC = true; # upstreamed in kernel 6.7

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.dconf.enable = true;

  programs.nix-ld.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
    docker.enable = true;
  };
  services.spice-vdagentd.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware = {
    opengl.enable = true;
  };

  # # XDG portal
  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # kde
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.desktopManager.plasma6.enable = true;
  security.pam.services.sddm.enableKwallet = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  plasma-browser-integration
  konsole
  oxygen
];


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "steven";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enable fingerprint reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  security.polkit.enable = true;



  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # nix search <package name>
  environment.systemPackages = with pkgs; [
    home-manager
    gnumake
    gcc
    libgcc
    cmake
    spice
    spice-gtk
    spice-protocol
    dnsmasq
  ];

  programs.virt-manager.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
  ];

  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
    pioRules
  ];

  programs.zsh.enable = true;
  users.users.steven.shell = pkgs.zsh;


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
