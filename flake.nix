{
  description = "AeroSpace sticky-layout fork build environment";

  inputs.nixpkgs.url = "tarball+https://github.com/NixOS/nixpkgs/archive/f361a82ad8e4170a3bcdcfa7816206d8f5fd066e.tar.gz";

  outputs =
    { nixpkgs, ... }:
    let
      forAllDarwin = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      mkAerospace =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          version = "0.21.3-Beta-sticky.2";
        in
        pkgs.aerospace.overrideAttrs (_previous: {
          inherit version;
          src = pkgs.fetchzip {
            url = "https://github.com/gakonst/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
            hash = "sha256-kfBuiSpZ9adOE7YKZ1V0OGqGpKyjr0RQBO6b8jUQLX0=";
          };

          # Stripping rewrites the Mach-O binaries and invalidates the release
          # signatures used by macOS Accessibility permissions.
          dontStrip = true;
        });
    in
    {
      packages = forAllDarwin (system: {
        default = mkAerospace system;
        aerospace = mkAerospace system;
      });

      devShells = forAllDarwin (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          xcodegen = pkgs.stdenvNoCC.mkDerivation {
            pname = "xcodegen";
            version = "2.45.3";
            src = pkgs.fetchurl {
              url = "https://github.com/yonaskolb/XcodeGen/releases/download/2.45.3/xcodegen.artifactbundle.zip";
              hash = "sha256-ajy4QYPH/Ijr4Hlq9qhLvwewBbzcYequ8TqKZh0Gdbg=";
            };
            dontUnpack = true;
            installPhase = ''
              runHook preInstall
              ${pkgs.unzip}/bin/unzip "$src" -d unpacked
              mkdir -p "$out"
              cp -R \
                unpacked/xcodegen.artifactbundle/xcodegen-2.45.3-macosx/bin \
                "$out/bin"
              runHook postInstall
            '';
          };
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              asciidoctor
              bash
              bundler
              cargo
              complgen
              fish
              git
              ruby
              rustc
              xcbeautify
              xcodegen
            ];
          };
        }
      );

      formatter = forAllDarwin (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
