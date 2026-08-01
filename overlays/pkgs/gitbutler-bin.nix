self: super:

let
    pname = "gitbutler-bin";
    version = "0.16.10";
    revision = "2482";

    srcArchive = super.fetchzip {
        url = "https://releases.gitbutler.com/releases/release/${version}-${revision}/linux/x86_64/GitButler_${version}_amd64.AppImage.tar.gz";
        sha256 = "01marw05sp9p5z1kgi6ysnhnhcv9w5jx2qfjjznj54wcpfgxm0n9";
    };

    src = "${srcArchive}/GitButler_${version}_amd64.AppImage";
in
{
    gitbutler-bin = super.appimageTools.wrapType2 {
        inherit pname src;

        version = "${version}-${revision}";

        # extraPkgs =
        #     pkgs: with pkgs; [
        #         icu
        #     ];
    };
}
