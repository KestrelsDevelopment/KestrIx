{ lib, ... }:

{
    options.kestrix.pkgs = {
        allowInsecure = lib.mkEnableOption "all insecure packages";
        allowUnfree = lib.mkEnableOption "unfree packages";
    };
}
