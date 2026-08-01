{
    nixpkgs.overlays = [
        (import ./pkgs/gitbutler-bin.nix)
        (import ./pkgs/convergence-mod-launcher.nix)
    ];
}
