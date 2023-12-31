  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [pynvim]); 
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      plenary-nvim
      gruvbox-nvim
      mini-nvim
      nvim-cmp
      telescope-nvim
      lualine-nvim
      gitsigns-nvim
      luasnip
      comment-nvim
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua} 
    '';
  };
