{config, pkgs, ... }:
{
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [pynvim]); 
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua} 
      ${builtins.readFile ./nvim/mappings.lua} 
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      plenary-nvim
      mini-nvim
      nvim-cmp
      # luasnip
      telescope-nvim
      {
        plugin = nvim-tree-lua;
        config = toLuaFile ./nvim/plugins/nvim-tree.lua;
      }
      {
        plugin = nvim-web-devicons;
        config = toLua "require(\"nvim-web-devicons\").setup()";
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugins/lualine.lua;
      }
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./nvim/plugins/gitsigns.lua;
      }
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()"; 
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
    ];
  };
}
