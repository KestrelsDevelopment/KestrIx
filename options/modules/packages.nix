{ config, ... }:

{
    imports = [ ./packages.option.nix ];

    config = {
        environment.systemPackages = config.kestrIx.packages.default ++ config.kestrIx.packages.stable;
    };
}
