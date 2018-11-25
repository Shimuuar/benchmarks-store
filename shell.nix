let
  pkgs   = import <nixpkgs> {inherit config; overlays=[];};
  config = {};
  # Python packages
  python = pkgs.python36;
  pyp = python.withPackages (ps: with ps;
    [ jupyter_core
      jupyter_client
      notebook
      ipywidgets
      #
      psycopg2
      #
      matplotlib
      numpy
      scipy
      pandas
      statsmodels
    ]);
in
  pkgs.stdenv.mkDerivation {
    name        = "shell";
    buildInputs = [ pyp ];
  }
