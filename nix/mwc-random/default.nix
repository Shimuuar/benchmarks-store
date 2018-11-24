{ url, rev, sha256 } :
let
  pkgs   = import <nixpkgs> { config = config; overlays=[]; };
  config = {
    packageOverrides = old: rec {
      haskellPackages = old.haskellPackages.override haskOverrides;
    };
  };
  lib = pkgs.haskell.lib;
  haskOverrides = {
    overrides = hsPkgNew: hsPkgOld: rec {
      mwc-random       = lib.dontCheck (hsPkgOld.callPackage (import ./mwc-random.nix {inherit url rev sha256;}) {});
      mwc-random-bench =
        lib.doBenchmark (lib.dontCheck
          (hsPkgOld.callPackage (import ./mwc-random-bench.nix {inherit url rev sha256;}) {})
        );
    };
  };
in pkgs.haskellPackages.mwc-random-bench.env
