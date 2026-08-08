self: super:

let
    pname = "convergence-mod-launcher";
    version = "1.0.3.1";

    src = super.fetchurl {
        url = "https://github.com/The-Convergence-Team/ConvergenceER-Public/releases/download/v${version}/ConvergenceLauncher_linux.AppImage";
        sha256 = "0r6ghqkbr62qicp5dq9hqrlkjbk9g5jq065fanlaqi27ixkjnnfq";
    };

    icon = ../assets/convergence-mod-launcher.png;
in
{
    convergence-mod-launcher = super.appimageTools.wrapType2 {
        inherit version pname src;

        extraPkgs =
            pkgs: with pkgs; [
                icu
            ];

        nativeBuildInputs = [
            super.copyDesktopItems
        ];

        desktopItems = [
            (super.makeDesktopItem {
                name = "ELDEN RING - The Convergence";
                exec = "convergence-mod-launcher %U";
                icon = "convergence-mod-launcher";
                desktopName = "ELDEN RING - The Convergence";
                comment = "The Convergence mod for ELDEN RING";
                categories = [ "Gaming" ];
                startupWMClass = "convergence-mod-launcher";
            })
        ];

        extraInstallCommands = ''
            copyDesktopItems

            install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/convergence-mod-launcher.png
        '';
    };
}
