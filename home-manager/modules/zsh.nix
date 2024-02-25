{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ thefuck ];
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
    enableAutosuggestions = true;
  };
}
