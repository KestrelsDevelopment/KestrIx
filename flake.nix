{
    description = "KESTR/X Lib";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        flakeInputs@{ home-manager, ... }:
        let
            lib =
                {
                    system,
                    inputs,
                    flake,
                    flakePath ? "",
                    user ? "",
                    ...
                }:
                (import ./. {
                    inputs = flakeInputs // inputs;
                    inherit
                        system
                        flake
                        flakePath
                        user
                        ;
                });
        in
        {
            inherit lib;

            lib_x86_64-linux =
                {
                    inputs,
                    flake,
                    flakePath ? "",
                    user ? "",
                    ...
                }:
                lib {
                    system = "x86_64-linux";
                    inherit
                        inputs
                        flake
                        flakePath
                        user
                        ;
                };
        };
}
