{
  description = "AeroSpace sticky-layout fork build environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/f361a82ad8e4170a3bcdcfa7816206d8f5fd066e";

  outputs =
    { nixpkgs, ... }:
    let
      forAllDarwin = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
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
              install -Dm755 \
                unpacked/xcodegen.artifactbundle/xcodegen-2.45.3-macosx/bin/xcodegen \
                "$out/bin/xcodegen"
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
