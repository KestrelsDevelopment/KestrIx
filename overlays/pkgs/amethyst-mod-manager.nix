{
    callPackage,
    fetchFromGitHub,
}:

let
    version = "2.6.3";
    src = fetchFromGitHub {
        owner = "ChrisDKN";
        repo = "Amethyst-Mod-Manager";
        tag = "v${version}";
        hash = "sha256-jd99jkUj4aAxsqw9aAnEt1v3h4XKsL8QtmLDeF6bGpg=";
    };
in
callPackage (src + "/nix/package.nix") { inherit version src; }
