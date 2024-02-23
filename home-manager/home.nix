# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
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
      zathura
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      docker
    ]);
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "deck" = {
        port = 22;
        hostname = "192.168.1.152";
        user = "deck";
      };
      "ubuntu-dev" = {
        port = 22;
        hostname = "192.168.122.99";
        user = "steven";
      };
    };
  };

 programs = {
  direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  bash.enable = true; # see note on other shells below
};

  home.file.".ssh/config" = {
  target = ".ssh/config_source";
  onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "github@arrownoon.maskmy.id";
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
