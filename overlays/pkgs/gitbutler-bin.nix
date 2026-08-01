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

    icon = super.fetchurl {
        url = "https://camo.githubusercontent.com/9c6adb93179b0f1f14ddb23ebe36247b56d9b707db9ea1946b77d5476983a7d8/68747470733a2f2f6769746275746c65722d646f63732d696d616765732d7075626c69632e73332e75732d656173742d312e616d617a6f6e6177732e636f6d2f6d642d6c6f676f2e706e67";
        sha256 = "0dwv8n1rdyimwxqm8x100r4sdxsa1hrjw13s4jh9c3wbh9ykdwbk";
    };
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
                icon = "gitbutler";
                desktopName = "GitButler";
                comment = "Git client";
                categories = [ "Utility" ];
                startupWMClass = "gitbutler";
            })
        ];

        extraInstallCommands = ''
            copyDesktopItems

            install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/gitbutler.png
        '';
    };
}
