{
    lib,
    config,
    kestrix,
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

    pkgsFromBranch =
        { revision, ... }:
        if revision == "stable" then
            pkgsStable
        else if revision == "unstable" then
            pkgsUnstable
        else
            pkgsMaster;

    mkOverlaysForRevs = pins: kestrix.overlays.mkOverlays (mapAttrs (k: v: v.revision) pins);
    mkOverlaysForBranch =
        pins:
        lib.mapAttrsToList kestrix.overlays.mkOverlayFromPkgs (mapAttrs (k: v: (pkgsFromBranch v)) pins);
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

            pinnedBySha = filterAttrs (k: v: isSha v) pinnedByRev;
            pinnedToBranch = filterAttrs (k: v: isBranch v) pinnedByRev;
        in
        {
            nixpkgs.overlays = (mkOverlaysForRevs pinnedBySha) ++ (mkOverlaysForBranch pinnedToBranch);
        };
}
