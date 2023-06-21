{ lib, fetchzip }:

let
  version = "1.8.0";
in

fetchzip rec {
  name = "renogare-${version}";

  extension = "zip";

  stripRoot = false;

  url = "https://dl.dafont.com/dl/?f=renogare";

  postFetch = ''
    mkdir -p $out/share/fonts
    rm $out/'renogare license.pdf'
    mv $out/*.otf $out/share/fonts/
  '';

  sha256 = "sha256-qJLayeF+mWnC4Igw3mdw17GV5s2oJvcOOWAegrA2mDI=";

  meta = with lib; {
    homepage = "https://github.com/spinda/fantasque-sans-ligatures";
    description = "A clean and elegant sans serif font created by Deepak Dogra";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
