#!/bin/sh

cd notebooks
nix-shell ../shell.nix --run 'jupyter notebook --no-browser'
