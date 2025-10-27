self: super:

let
    pname = "gitbutler";
    version = "0.16.10";
    revision = "2482";

    srcArchive = super.fetchzip {
        url = "https://releases.gitbutler.com/releases/release/${version}-${revision}/linux/x86_64/GitButler_${version}_amd64.AppImage.tar.gz";
        hash = "01marw05sp9p5z1kgi6ysnhnhcv9w5jx2qfjjznj54wcpfgxm0n9";
    };

    appImage = "${srcArchive}/GitButler_${version}_amd64.AppImage";
in
{
    gitbutler-bin = super.appimageTools.wrapType2 {
        inherit pname version;
        src = appImage;

        extraInstallCommands = ''
            for f in $out/share/applications/*.desktop; do
              [ -e "$f" ] || continue
              substituteInPlace "$f" \
                --replace-fail 'Exec=AppRun' 'Exec=${pname}'
            done
        '';

        meta = with super.lib; {
            description = "Git client for simultaneous branches";
            homepage = "https://gitbutler.com";
            license = licenses.fsl11Mit;
            mainProgram = pname;
            platforms = [ "x86_64-linux" ];
        };
    };
}
