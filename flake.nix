{
  description = "Wrap Gradle builds with Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
        };
      in rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ kotlin-language-server ktlint pkgs.jdk8 ];
        };

        packages.default = import ./default.nix { inherit pkgs; };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/gradle2nix";
        };
      });
}
