# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # ./neovim.nix
    ./kitty.nix
    ./wlogout.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "steven";
    homeDirectory = "/home/steven";
    packages = with pkgs; [
      signal-desktop
      discord
      mullvad
      bitwarden
      cinny-desktop
      fd
      nodejs
      zotero
      cargo
      pywal
      gimp
      zoom-us
      obs-studio
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-vaapi
      jetbrains.clion
      jetbrains.pycharm-professional
      platformio-core
    ];
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  home.file."./.config/nvim/" = {
    source = ./AstroNvim;
    recursive = true;
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
  };


  programs.ssh = {
    enable = true;
    extraConfig = 
    ''
    Host deck
      HostName 192.168.1.152
      User deck
      Port 22
      IdentityFile ~/.ssh/id_ed25519
    '';
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "github@arrownoon.maskmy.id";
    userName = "steven";
  };

  # home.pointerCursor = {
  #   name = "Adwaita";
  #   package = pkgs.gnome.adwaita-icon-theme;
  #   size = 24;
  #   x11 = {
  #     enable = true;
  #     defaultCursor = "Adwaita";
  #   };
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
