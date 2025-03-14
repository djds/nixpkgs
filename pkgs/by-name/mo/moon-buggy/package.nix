{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "moon-buggy";
  version = "1.0.51";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "http://m.seehuhn.de/programs/moon-buggy-${version}.tar.gz";
    sha256 = "0gyjwlpx0sd728dwwi7pwks4zfdy9rm1w1xbhwg6zip4r9nc2b9m";
  };

  meta = {
    description = "Simple character graphics game where you drive some kind of car across the moon's surface";
    mainProgram = "moon-buggy";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rybern ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    homepage = "https://www.seehuhn.de/pages/moon-buggy";
  };
}
