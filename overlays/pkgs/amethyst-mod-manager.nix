{
    callPackage,
    fetchFromGitHub,
}:

let
    version = "2.6.4";
    src = fetchFromGitHub {
        owner = "ChrisDKN";
        repo = "Amethyst-Mod-Manager";
        tag = "v${version}";
        hash = "sha256-F/W259hSzYoINXgmjQwihNuLT9+upSEljCwWVypzvB4=";
    };
in
callPackage (src + "/nix/package.nix") { inherit version src; }
