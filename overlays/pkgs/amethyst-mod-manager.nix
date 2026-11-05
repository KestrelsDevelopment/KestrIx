{
    fetchurl,
    stdenv,
    dwarfs,
    makeWrapper,
    ...
}:

let
    pname = "amethyst-mod-manager";
    version = "2.6.1";

    src = fetchurl {
        url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager-${version}-x86_64.AppImage";
        sha256 = "1rxzk6zryynzv1msy6aafdfmr9i95bbwrvf3z54h01j2j7imycrg";
    };
in
stdenv.mkDerivation {
    inherit version pname src;

    nativeBuildInputs = [
        dwarfs
        makeWrapper
    ];
    dontUnpack = true;

    # sharun bundles its own libraries; Nix's patching and stripping would break them
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
        runHook preInstall

        mkdir extracted
        dwarfsextract --image-offset=1507016 -i $src -o extracted

        # Keep the whole bundle together under libexec
        mkdir -p $out/libexec/amethyst-mod-manager
        cp -a extracted/. $out/libexec/amethyst-mod-manager/

        # Wrapper that starts the bundle's AppRun
        mkdir -p $out/bin
        makeWrapper $out/libexec/amethyst-mod-manager/AppRun $out/bin/amethyst-mod-manager

        # Desktop entry and icon
        install -Dm644 extracted/mod-manager.desktop $out/share/applications/mod-manager.desktop
        sed -i 's|^Exec=.*|Exec=amethyst-mod-manager|' $out/share/applications/mod-manager.desktop
        install -Dm644 extracted/mod-manager.png $out/share/pixmaps/mod-manager.png

        runHook postInstall
    '';

    meta = {
        description = "Amethyst Mod Manager";
        platforms = [ "x86_64-linux" ];
    };
}
