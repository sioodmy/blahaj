{
  description = "Display cute sharks in your terminal :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # https://github.com/nix-systems/nix-systems
      systems = import inputs.systems;
      perSystem = {pkgs, ...}: let
        inherit (inputs.nixpkgs) lib;
      in {
        packages.default = let
          blahaj-assets = pkgs.stdenv.mkDerivation {
            name = "blahaj-assets";
            src = lib.cleanSourceWith {
              filter = name: _: let
                baseName = baseNameOf (toString name);
              in
                ! (lib.hasSuffix ".nix" baseName);
              src = lib.cleanSource ./assets;
            };
            installPhase = ''
              runHook preInstall
              mkdir -p $out/usr/share/uwu
              cp $src/* $out/usr/share/uwu
              runHook postInstall
            '';
          };
        in
          pkgs.writeShellScriptBin ":3" ''
            #!/bin/sh
            img=$(find ${blahaj-assets}/usr/share/uwu -type f | shuf -n 1)
            ${pkgs.libsixel}/bin/img2sixel $img -w 300
          '';
      };
    };
}
