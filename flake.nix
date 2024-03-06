{
  description = "retry-mabl-cli";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.nodePackages.pnpm
            pkgs.just
            pkgs.shellspec
            pkgs.nixpkgs-fmt
            pkgs.shellcheck
            pkgs.shfmt
          ];
          shellHook = "
            pnpm add -g  @mablhq/mabl-cli
          ";
        };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
