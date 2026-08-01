self: super:

let
    pname = "gitbutler-bin";
    version = "0.16.10";
    revision = "2482";

    srcArchive = super.fetchzip {
        url = "https://releases.gitbutler.com/releases/release/${version}-${revision}/linux/x86_64/GitButler_${version}_amd64.AppImage.tar.gz";
        sha256 = "1v5yzgi7p6hs89axlvsa86rg65b6gfi0ksvf404cgsrz85xii57j";
    };

    src = "${srcArchive}/GitButler_${version}_amd64.AppImage";
in
{
    gitbutler-bin = super.appimageTools.wrapType2 {
        inherit pname src;

        version = "${version}-${revision}";
    };
}
