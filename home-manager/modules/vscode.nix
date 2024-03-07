{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      docker
      rustup 
      zlib 
      openssl.dev 
      pkg-config
      conda
      brave
    ]);
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      ms-azuretools.vscode-docker
      vscodevim.vim
      james-yu.latex-workshop
      shd101wyy.markdown-preview-enhanced
      rust-lang.rust-analyzer
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      mechatroner.rainbow-csv
      oderwat.indent-rainbow
      ms-python.vscode-pylance
      ms-python.python
      ms-python.black-formatter
      prisma.prisma
      esbenp.prettier-vscode
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
      donjayamanne.githistory
      mhutchie.git-graph
      twxs.cmake
      ms-vscode.cmake-tools
      ms-vscode.cpptools
    ];
  };
}
