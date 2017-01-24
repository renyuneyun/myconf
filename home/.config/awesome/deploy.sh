#!/bin/sh

srcdir=$1
dstdir=$2

mkdir $dstdir
for file in rc.lua panels.lua freedesktop; do
	ln -sr $file $dstdir/$file
done

