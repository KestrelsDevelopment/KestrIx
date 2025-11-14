{ config, lib, ... }:

{
    imports = [ ./packages.option.nix ];

    config =
        lib.mkIf config.kestrix.pkgs.allowInsecure {
            nixpkgs.config.allowInsecurePredicate = lib.mkDefault (_: true);
        }
        // lib.mkIf config.kestrix.pkgs.allowUnfree {
            nixpkgs.config.allowUnfree = lib.mkDefault true;
        };
}
