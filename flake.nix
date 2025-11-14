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
                    src ? null,
                    user ? null,
                    ...
                }:
                (import ./lib {
                    inputs = flakeInputs // inputs;
                    inherit
                        system
                        flake
                        src
                        user
                        ;
                });
        in
        {
            inherit lib;

            overlays = (import ./overlays/overlays.nix);

            mkConfig =
                {
                    system,
                    inputs,
                    flake,
                    src ? null,
                    user ? null,
                    modules ? null,
                    specialArgs ? null,
                    hostname ? null,
                    ...
                }:
                let
                    kestrix = lib {
                        inherit
                            system
                            inputs
                            flake
                            src
                            user
                            ;
                    };
                in
                kestrix.config.mkConfig {
                    inherit
                        modules
                        specialArgs
                        hostname
                        kestrix
                        ;
                };
        };
}
