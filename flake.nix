{
  description = "Packaging for WebBT server side for Firefox Plugin";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, lib, crane, fenix, system, ... }: {
         packages =
           let
             craneLib = (inputs.crane.mkLib pkgs).overrideToolchain
               inputs.fenix.packages.${system}.minimal.toolchain;
           in
         rec {
           default = webbt_firefox_nix_server;
           webbt_firefox_nix_server = pkgs.callPackage ./package.nix { inherit pkgs craneLib; };
        };
      };
    };
}
