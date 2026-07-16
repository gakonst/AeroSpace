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
