# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./modules/kitty.nix
    ./modules/vscode.nix
    ./modules/ssh-config.nix
    ./modules/zsh.nix
    ./modules/direnv.nix
  ];

  nixpkgs = {
    overlays = [
      # TODO: Learn what overlays are
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "steven";
    homeDirectory = "/home/steven";
    packages = with pkgs; [
      git
      neovim
      brave
      kitty
      signal-desktop
      discord
      bitwarden
      element-desktop
      fd
      powertop
      nodejs
      zotero
      cargo
      rustfmt
      pywal
      gimp
      zoom-us
      obs-studio
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-vaapi
      jetbrains.clion
      jetbrains.pycharm-professional
      nixpkgs-fmt
      lf
      virt-viewer
      python3
      ripgrep
      lazygit
      tmux
      curl
      wget
      protonvpn-cli
      libreoffice-qt
      texliveMedium
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./modules/AstroNvim;
    recursive = true;
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "stevenwt01@pm.me";
    userName = "steven";
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
