{
  description = "Juice basic setup";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    spotifast.url = "github:crmne/spotifast";
    slk.url = "github:gammons/slk";
  };

  outputs =  inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              # Add exact unfree package names here, e.g.:
              "barbar.nvim"
            ];
        };
        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };

    in {
      devShells.${system}.suckless = pkgs.mkShell {
        packages = with pkgs; [
          pkg-config
          xorg.libX11
          xorg.libXft
          xorg.libXinerama
          fontconfig
          freetype
          harfbuzz
          gcc
          gnumake
        ];
      };

      nixosConfigurations = {
        juice = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs;};
          modules = [ 
            ./configuration.nix 
          ];
        };
      };

      homeConfigurations = {
        juice = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ 
            ./home.nix 
            nixvim.homeManagerModules.nixvim
          ];
        };
      };
  };
}
