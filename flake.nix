{
    description = "KESTR/X Lib";

    inputs = {
        nixpkgs.url = "git+https://github.com/NixOS/nixpkgs.git?shallow=1&ref=nixos-unstable";

        nixpkgs-stable.url = "git+https://github.com/NixOS/nixpkgs.git?shallow=1&ref=nixos-25.05";
        nixpkgs-unstable.url = "git+https://github.com/NixOS/nixpkgs.git?shallow=1&ref=nixos-unstable";
        nixpkgs-master.url = "git+https://github.com/NixOS/nixpkgs.git?shallow=1&ref=master";

        home-manager = {
            url = "git+https://github.com/nix-community/home-manager.git?shallow=1&ref=master";
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

            # overlays = (import ./overlays/overlays.nix);

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
