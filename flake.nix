{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { self, git-hooks, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              qmlformat = {
                enable = true;
                entry = "${pkgs.qt6.qtdeclarative}/bin/qmlformat";
                args = [ "--inplace" "--normalize" ];
                files = "\\.qml$";
              };
            };
          };
        };

        devShells.default = with nixpkgs.legacyPackages.${system};
          mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;

            buildInputs = [
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
