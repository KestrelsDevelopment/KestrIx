{ lib, ... }:

let
    inherit (lib) mkOption types literalExpression;

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
    options.kestrix.pins = mkOption {
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

                        # version = mkOption {
                        #     type = types.nullOr lib.types.str;
                        #     default = null;
                        #     example = "1.2.3";
                        #     description = ''
                        #         SemVer pin for the *package version* (e.g., "1.2.3").
                        #         Mutually exclusive with `revision`.
                        #     '';
                        # };
                    };
                }
            )
        );
        default = { };
        example = literalExpression "";
        description = "";
    };

    # Validate: exactly one of revision/version must be set for each pin.
    # config.assertions = lib.mapAttrsToList (key: pin: {
    #     assertion = (pin.revision != null) != (pin.version != null);
    #     message = "kestrIx.pins.${key}: set exactly one of `revision` or `version`.";
    # }) config.kestrix.pins;
}
