# overlays/overlays.nix
let
    pkgsDir = ./pkgs;

    removeNixFileExtension =
        str:
        let
            strLen = builtins.stringLength str;
        in
        builtins.substring 0 (strLen - 4) str;

    nixFiles = builtins.filter (name: builtins.match ".*\\.nix$" name != null) (
        builtins.attrNames (builtins.readDir pkgsDir)
    );

    allPackagesOverlay =
        final: prev:
        builtins.listToAttrs (
            map (file: {
                name = removeNixFileExtension file;
                value = final.callPackage (pkgsDir + "/${file}") { };
            }) nixFiles
        );
in
{
    default = allPackagesOverlay;
}
