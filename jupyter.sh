#!/bin/sh

export PYTHONPATH="$PWD/python"
cd notebooks
nix-shell ../shell.nix --run 'jupyter notebook --no-browser'
