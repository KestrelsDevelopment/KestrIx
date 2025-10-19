args@{
    system,
    inputs,
    flake,
    ...
}:
let
    nullable =
        args: defaults:
        args
        // builtins.mapAttrs (
            k: v: if builtins.hasAttr k args && args.${k} != null then args.${k} else v
        ) defaults;
in
with nullable args {
    src = "/etc/nixos";
    user = "";
};

let
    hm = inputs.home-manager.lib.hm;
    lib = inputs.nixpkgs.lib // {
        inherit hm;
    };

    importModule =
        m:
        lib.callPackageWith (
            {
                inherit
                    inputs
                    importModule
                    importModules
                    user
                    flake
                    src
                    ;
            }
            // exports
        ) m { };

    importModules = lib.mapAttrs (name: value: (importModule value));

    imports = importModules {
        assertions = ./modules/assertions.nix;
        overlays = ./modules/overlays.nix;
        config = ./modules/config.nix;
    };

    exports = imports // {
        inherit
            lib
            system
            hm
            nullable
            ;
    };
in
{
    mkHome = exports.config.mkHome;
    userModules = exports.config.userModules;
}
// exports
