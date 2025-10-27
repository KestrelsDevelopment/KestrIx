{
    nixpkgs.overlays = [
        (import ./pkgs/freelens.nix)
        (import ./pkgs/gitbutler-bin.nix)
    ];
}
