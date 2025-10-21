{ lib, ... }:

let
    inherit (lib) mkOption types literalExpression;
in
{
    options.kestrIx.packages = mkOption {
        type = types.submodule (
            { ... }:
            {
                options = {
                    default = mkOption {
                        type = types.listOf types.package;
                        default = [ ];
                        example = "";
                        description = "";
                    };
                    stable = mkOption {
                        type = types.listOf types.package;
                        default = [ ];
                        example = "";
                        description = "";
                    };
                };
            }
        );
        default = { };
        example = literalExpression "";
        description = "";
    };
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
