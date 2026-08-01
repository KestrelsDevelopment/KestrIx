self: super:

let
    pname = "gitbutler-bin";
    version = "0.16.10";
    revision = "2482";

    srcArchive = super.fetchzip {
        url = "https://releases.gitbutler.com/releases/release/${version}-${revision}/linux/x86_64/GitButler_${version}_amd64.AppImage.tar.gz";
        sha256 = "sha256-RT21f0z2PfNC8nt1fX2hQzmjDgVGaSqwK1Vf6ZqUT78=";
    };

    src = "${srcArchive}/GitButler_${version}_amd64.AppImage";
in
{
    gitbutler-bin = super.appimageTools.wrapType2 {
        inherit pname src;

        version = "${version}-${revision}";

        nativeBuildInputs = [
            super.copyDesktopItems
        ];

        desktopItems = [
            (super.makeDesktopItem {
                name = "GitButler";
                exec = "gitbutler-bin %U";
                desktopName = "gitbutler";
                comment = "GitButler";
                categories = [ "Graphics" ];
                startupWMClass = "gitbutler";
            })
        ];

        extraInstallCommands = ''
            # Force copyDesktopItems to run inside wrapType2's custom build script
            copyDesktopItems
        '';
    };
}
