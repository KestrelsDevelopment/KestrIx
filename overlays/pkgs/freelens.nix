self: super:

let
    pname = "freelens";
    version = "1.6.1";

    freelensAppImage = super.fetchurl {
        url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
        sha256 = "0sny05w0rrilrcxp61snyrxq2n6xsp11l7fz7h8hmsiccwwks826";
    };

    freelensIcon = super.fetchurl {
        url = "https://avatars.githubusercontent.com/u/172038998?v=4";
        sha256 = "00x31wps83h9gkca5rfyvvxnzz8vm8kzcfgxlj1g12652y42n8kb";
    };
in
{
    freelens = super.stdenv.mkDerivation {
        inherit version pname;

        nativeBuildInputs = [ super.appimage-run ];
        src = null;
        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p \
                $out/bin \
                $out/share/applications \
                $out/share/icons/hicolor/256x256/apps

            cp ${freelensAppImage} $out/Freelens.AppImage

            cat > $out/bin/freelens <<EOF
            #!${super.runtimeShell}
            exec ${super.appimage-run}/bin/appimage-run $out/Freelens.AppImage "\$@"
            EOF
            chmod +x $out/bin/freelens

            cat > $out/share/applications/freelens.desktop <<EOF
            [Desktop Entry]
            Name=Freelens
            Comment=Free IDE for Kubernetes 
            Exec=$out/bin/freelens %U
            Icon=freelens
            Type=Application
            Categories=Development;Utilities;
            Terminal=false
            EOF

            cp ${freelensIcon} \
                $out/share/icons/hicolor/256x256/apps/freelens.png
        '';
    };
}
