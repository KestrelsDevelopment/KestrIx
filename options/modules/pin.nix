{
    lib,
    config,
    kestrel,
    pkgsStable,
    pkgsUnstable,
    pkgsMaster,
    ...
}:

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
let
    inherit (lib) filterAttrs mapAttrs;

    copyAttrByPath =
        path: source: if path == [ ] then { } else lib.setAttrByPath path (lib.getAttrFromPath path source);

    mkOverlayFrom =
        package: source:
        (
            final: prev:
            let
                path = lib.splitString "." package; # list of path segments

                existing = copyAttrByPath (lib.init path) prev;
                updated = copyAttrByPath path source;
            in
            lib.recursiveUpdate existing updated
        );

    mkOverlaysForRevs = pins: kestrel.overlays.mkOverlays (mapAttrs (k: v: v.revision) pins);
    mkOverlaysForBranch = pins: lib.mapAttrsToList mkOverlayFrom pins;
in
{
    imports = [ ./pin.option.nix ];

    config =
        let
            allPins = config.kestrIx.pins;

            pinnedByRev = filterAttrs (k: v: (v.revision ? null) != null) allPins;
            # pinnedToVersion = filterAttrs (k: v: (v.version ? null) != null) allPins;

            isSha = { revision, ... }: (builtins.match "^[0-9a-f]{40}$" revision) != null;
            isBranch =
                { revision, ... }: (revision == "stable") || (revision == "unstable") || (revision == "master");

            pkgsFromBranch =
                { revision, ... }:
                if revision == "stable" then
                    pkgsStable
                else if revision == "unstable" then
                    pkgsUnstable
                else
                    pkgsMaster;

            pinnedBySha = filterAttrs (k: v: isSha v) pinnedByRev;
            pinnedToBranch = mapAttrs (k: v: (pkgsFromBranch v)) (filterAttrs (k: v: isBranch v) pinnedByRev);
        in
        {
            nixpkgs.overlays = (mkOverlaysForRevs pinnedBySha) ++ (mkOverlaysForBranch pinnedToBranch);
        };
}
