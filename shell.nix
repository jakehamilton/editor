{ config }:

{
  config.shells.default = {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    shell = { pkgs, lib, mkShell, vimPlugins, neovim-unwrapped, fnlfmt, ... }:
      let
        pname = "editor";

        basePackage = neovim-unwrapped;

        inherit (basePackage) lua;
        inherit (lua.pkgs) luaLib;
        luaEnv = lua.withPackages (packages: with packages; [
          fennel
          luafilesystem
        ]);
      in
      mkShell {
        packages = [
          luaEnv
          fnlfmt
        ];
      };
  };
}
