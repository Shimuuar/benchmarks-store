{ url,
  rev,
  sha256
}:
{ mkDerivation, fetchgit, base, math-functions, primitive, stdenv, time
, vector
}:
mkDerivation {
  pname = "mwc-random";
  version = "0.14.0.0";
  src = fetchgit {
    url    = url;
    rev    = rev;
    sha256 = sha256;
  };
  libraryHaskellDepends = [
    base math-functions primitive time vector
  ];
  doCheck = false;
  homepage = "https://github.com/bos/mwc-random";
  description = "Fast, high quality pseudo random number generation";
  license = stdenv.lib.licenses.bsd3;
}
