{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      docker
      conda
    ]);
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      rust-lang.rust-analyzer
      tomoki1207.pdf
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      zhuangtongfa.material-theme
      mechatroner.rainbow-csv
      oderwat.indent-rainbow
      ms-python.vscode-pylance
      ms-python.python
      ms-python.black-formatter
      prisma.prisma
      esbenp.prettier-vscode
      jnoortheen.nix-ide
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
      donjayamanne.githistory
      mhutchie.git-graph
      ms-azuretools.vscode-docker
      twxs.cmake
      ms-vscode.cmake-tools
      ms-vscode.cpptools
    ];
  };


}
