{ url,
  rev,
  sha256
}:
{ mkDerivation, fetchgit, base, criterion, HUnit, mersenne-random, mwc-random
, QuickCheck, random, statistics, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, vector
}:
mkDerivation {
  pname = "mwc-random-bench";
  version = "0";
  src = fetchgit {
    url    = url;
    rev    = rev;
    sha256 = sha256;
  };
  postUnpack = "sourceRoot+=/mwc-random-bench; echo source root reset to $sourceRoot";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base mwc-random ];
  testHaskellDepends = [
    base HUnit mwc-random QuickCheck statistics test-framework
    test-framework-hunit test-framework-quickcheck2 vector
  ];
  benchmarkHaskellDepends = [
    base criterion mersenne-random mwc-random random vector
  ];
  description = "Benchmarks for the mwc-random package";
  license = stdenv.lib.licenses.bsd3;
}
