{ pkgs, lib, ... }:

{
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    #colorschemes.gruvbox.enable = true;
    colorschemes.tokyonight.enable = true;
    plugins.lightline.enable = true;
    extraConfigLua = lib.fileContents ./init.lua;
    plugins.treesitter = {
      enable = true;
    };

    clipboard.register = "unnamedplus";

    plugins.telescope = {
      enable = true;
      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>pf" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>b" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = "oldfiles";
        "<C-f>" = "live_grep";
      };
    };


    plugins.barbar = {
      enable = true;
    };

    plugins.comment = {
      enable = true;
    };

	  plugins = {
	  	luasnip = {
	  		enable = true;
	  		extraConfig = {
	  			enable_autosnippets = true;
	  			store_selection_keys = "<Tab>";
	  		};
	  		fromVscode = [
	  		{
	  			lazyLoad = true;
	  			paths = "${pkgs.vimPlugins.friendly-snippets}";
	  		}
	  		];
	  	};
	  	cmp_luasnip = {
	  		enable = true;
	  	};
	  	cmp-nvim-lsp = {
	  		enable = true;
	  	};
	  	cmp = {
	  		enable = true;
	  		autoEnableSources = true;
	  		settings = {
	  			mapping = {
	  				"<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  				"<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
	  				"<CR>" = "cmp.mapping.confirm({ select = true })";
	  			};
	  			sources = [
	  			  {name = "nvim_lsp";}
	  			  {name = "luasnip";}
	  			  {name = "path";}
	  			  {name = "buffer";}
	  			];
          snippet.expand = ''function(args) require('luasnip').lsp_expand(args.body) end'';
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
	  		};
	  	};

	  };

    plugins.lsp-lines = {
      enable = true;
    };

    plugins.lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          gD = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<F2>" = "rename";
        };
      };
      servers = {
	      tsserver.enable = true;
	      eslint.enable = true;
	      graphql.enable = true;
	      html.enable = true;
	      nixd.enable = true;
        gopls.enable = true;
        prismals.enable = true;
        pyright.enable = true;
        templ.enable = true;
        typos-lsp.enable = true;
      };
    };

    # plugins.lsp-format.enable = true;

    plugins.none-ls = {
      enable = true;
      # enableLspFormat = true;
      sources = {
        diagnostics.stylelint.enable = true;
      };
    };
}
