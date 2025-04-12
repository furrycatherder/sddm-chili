{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            qt6.qtdeclarative
            qt6.qttools

            qt6.qtdeclarative.dev
            nodePackages.typescript-language-server # Helps with JS parts

            kdePackages.sddm
            libsForQt5.qtstyleplugin-kvantum
          ];
        };
      });
}
