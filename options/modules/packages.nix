{
    lib,
    config,
    ...
}:

let
    inherit (lib) mkOption types literalExpression;

    # Accept either a full 40-char sha1 or a channel alias
    sha1Regex = "^[0-9a-f]{40}$";

    revType = types.oneOf [
        (types.enum [
            "stable"
            "unstable"
            "master"
        ])
        (types.strMatching sha1Regex)
    ];
in
{
    options.kestrIx = {
        packages = mkOption {
            type = types.attrsOf (types.listOf types.package);
            default = { };
            example = literalExpression "";
            description = "";
        };

        pins = mkOption {
            type = types.attrsOf (
                types.submodule (
                    { ... }:
                    {
                        options = {
                            revision = mkOption {
                                type = types.nullOr revType;
                                default = null;
                                example = "8eaee110344796db060382e15d3af0a9fc396e0e";
                                description = ''
                                    nixpkgs pin for this key. Either a 40-character commit SHA, or
                                    one of: "stable", "unstable", "master".
                                '';
                            };

                            version = mkOption {
                                type = types.nullOr lib.types.string;
                                default = null;
                                example = "1.2.3";
                                description = ''
                                    SemVer pin for the *package version* (e.g., "1.2.3").
                                    Mutually exclusive with `revision`.
                                '';
                            };
                        };
                    }
                )
            );
            default = { };
            example = literalExpression "";
            description = "";
        };
    };

    # Validate: exactly one of revision/version must be set for each pin.
    config.assertions = lib.mapAttrsToList (key: pin: {
        assertion = (pin.revision != null) != (pin.version != null);
        message = "kestrIx.pins.${key}: set exactly one of `revision` or `version`.";
    }) config.kestrIx.pins;
}

# { pkgs, ... }:

# {
#     # example:
#     kestrIx.packages = {
#         # install packages from default pkgs
#         default = with pkgs; [
#             foo
#         ];

#         # install packages pinned to "stable" pkgs
#         stable = with pkgs; [
#             bar
#         ];
#     };

#     kestrIx.pins = {
#         # namespace pinned to nixpkgs revision
#         jetbrains.revision = "8eaee110344796db060382e15d3af0a9fc396e0e"; # commit SHA

#         # nested package pinned to nixpkgs revision
#         "jetbrains.rider".revision = "8eaee110344796db060382e15d3af0a9fc396e0e";

#         # top-level package pinned to nixpkgs revision
#         baz.revision = "8eaee110344796db060382e15d3af0a9fc396e0e";

#         # package pinned to latest commit for package version
#         qix.version = "1.2.3"; # SemVer

#         # package pinned to "stable" pkgs
#         goo.revision = "stable"; # stable | unstable | master
#     };
# }
