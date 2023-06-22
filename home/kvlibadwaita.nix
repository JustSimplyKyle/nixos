{ lib, stdenv, fetchFromGitHub, fetchpatch, gitUpdater }:
stdenv.mkDerivation rec {
  pname = "KvLibadwaita";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "HEAD";
    sha256 = "sha256-65Gz3WNAwuoWWbBZJL0Ifl+PVLOHjpl6GNhR1oVmGZ0=";
  };

  sourceRoot = "source/src";

  installPhase = ''
    ls
    mkdir -p $out/share/Kvantum
    mv ./* $out/share/Kvantum
  '';

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    maintainers = [ maintainers.bugworm ];
  };
}
