{
    system,
    inputs,
    lib,
    hm,
    user,
    flake,
    src,
    nullable,
    ...
}:

let
    pkgsConfig = {
        allowUnfree = lib.mkForce true;
    };

    importPkgs =
        p: config:
        import p {
            inherit system config;
        };
in
{
    mkConfig =
        args@{ kestrix, ... }:
        with nullable args {
            modules = [ ];
            specialArgs = { };
            hostname = builtins.baseNameOf flake;
        };
        {
            ${hostname} = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = specialArgs // {
                    inherit
                        inputs
                        kestrix
                        lib
                        hm
                        ;
                    kestrel = kestrix;
                };
                modules = modules ++ [
                    (flake + "/device.nix")
                    (flake + "/hardware.nix")
                    (flake + "/state.nix")
                    inputs.home-manager.nixosModules.home-manager
                    ../options/options.nix
                    ../overlays/overlays.nix
                    {
                        environment.variables.FLAKE_PATH = lib.mkDefault src;
                        networking.hostName = lib.mkForce hostname;
                        nixpkgs.config = pkgsConfig;
                        nix.settings.experimental-features = [
                            "nix-command"
                            "flakes"
                        ];

                        home-manager = {
                            useGlobalPkgs = lib.mkDefault true;
                            useUserPackages = lib.mkDefault true;
                            backupFileExtension = lib.mkDefault "backup";
                        };

                        nixpkgs.overlays = [
                            (self: super: {
                                pkgsStable = importPkgs (inputs.nixpkgs-stable or inputs.nixpkgs) (prev.config or pkgsConfig);
                                pkgsUnstable = importPkgs (inputs.nixpkgs-unstable or inputs.nixpkgs) (prev.config or pkgsConfig);
                                pkgsMaster = importPkgs (inputs.nixpkgs-master or inputs.nixpkgs) (prev.config or pkgsConfig);
                            })
                        ];
                    }
                ];
            };
        };

    mkHome = m: {
        home-manager.sharedModules = [ m ];
    };

    userModules =
        {
            kes ? { },
            annika ? { },
            lexi ? { },
            ...
        }:
        (lib.optional (user == "kes") kes)
        ++ (lib.optional (user == "annika") annika)
        ++ (lib.optional (user == "lexi") lexi);
}
