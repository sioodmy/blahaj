{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages.default = let
          blahaj-assets = pkgs.stdenv.mkDerivation {
            name = "blahaj-assets";
            src = ./assets;
            installPhase = ''
              mkdir -p $out/usr/share/uwu
              cp $src/* $out/usr/share/uwu
            '';
          };
        in
          pkgs.writeShellScriptBin "blahaj" ''
            #!/bin/sh
            img=$(find ${blahaj-assets}/usr/share/uwu -type f | shuf -n 1)
            ${pkgs.libsixel}/bin/img2sixel $img -w 300
          '';
      };
    };
}
