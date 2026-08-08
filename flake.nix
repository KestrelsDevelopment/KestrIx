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
        flakeInputs@{
            self,
            nixpkgs,
            home-manager,
            ...
        }:
        let
            lib =
                {
                    system,
                    inputs,
                    flake,
                    src ? null,
                    user ? null,
                    tags ? null,
                    ...
                }:
                (import ./lib {
                    inputs = flakeInputs // inputs;
                    inherit
                        system
                        flake
                        src
                        user
                        tags
                        ;
                });

            supportedSystems = [
                "x86_64-linux"
                "aarch64-linux"
                "x86_64-darwin"
                "aarch64-darwin"
            ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        in
        {
            inherit lib;

            overlays = import ./overlays/overlays.nix;

            packages = forAllSystems (
                system:
                let
                    pkgs = import nixpkgs { inherit system; };
                in
                self.overlays.default pkgs pkgs
            );

            mkConfig =
                {
                    system,
                    inputs,
                    flake,
                    src ? null,
                    user ? null,
                    tags ? null,
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
                            tags
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
