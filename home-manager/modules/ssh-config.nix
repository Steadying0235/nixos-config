{ config, pkgs, ... }:
{
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

  # set permissions for vscode remote development
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
  };
}
