{
    nixpkgs.overlays = [
        ./pkgs/gitbutler-bin.nix
        ./pkgs/convergence-mod-launcher.nix
    ];
}
