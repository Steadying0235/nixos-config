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
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      plenary-nvim
      mini-nvim
      nvim-cmp
      telescope-nvim
      lualine-nvim
      luasnip
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./nvim/gitsigns.lua;
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
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua} 
    '';
  };
}
