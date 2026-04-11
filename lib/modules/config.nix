{
    system,
    inputs,
    lib,
    hm,
    user,
    tags,
    flake,
    src,
    nullable,
    ...
}:

let
    pkgsConfig = {
        allowUnfree = lib.mkForce true;
        allowInsecurePredicate = lib.mkDefault (_: true);
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
            hostname = baseNameOf flake;
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
                    (flake + "/hardware.nix")
                    (flake + "/state.nix")
                    inputs.home-manager.nixosModules.home-manager
                    ../../options/options.nix
                    ../../overlays/overlays.nix
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
                            (
                                self: super:
                                let
                                    config = (self.config.nixpkgs.config or pkgsConfig);
                                in
                                {
                                    pkgsStable = importPkgs (inputs.nixpkgs-stable or inputs.nixpkgs) config;
                                    pkgsUnstable = importPkgs (inputs.nixpkgs-unstable or inputs.nixpkgs) config;
                                    pkgsMaster = importPkgs (inputs.nixpkgs-master or inputs.nixpkgs) config;
                                }
                            )
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
        lib.warn "\"kestrix.config.userModules\" is deprecated" (
            (lib.optional (user == "kes") kes)
            ++ (lib.optional (user == "annika") annika)
            ++ (lib.optional (user == "lexi") lexi)
        );

    tagged =
        let
            flatten = lib.flatten;
            contains = list: item: lib.any (element: element == item) list;
            where =
                attrs: conditionTrueFor:
                lib.mapAttrsToList (name: value: if (conditionTrueFor name) then value else [ ]) attrs;
            taggedForSystem = args@{ ... }: flatten (where args (name: contains tags name));
        in
        attrs:
        taggedForSystem (
            lib.mapAttrs (
                name: value:
                lib.forEach value (
                    el: if lib.hasSuffix ".home.nix" el then { home-manager.users.${name}.imports = [ el ]; } else el
                )
            ) attrs
        );
}
