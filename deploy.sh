#!/usr/bin/zsh

function dealdir {
	local srcdir=$1;
	local dstdir=$2;
	local dirmade=false;
	for i in $(ls -A $srcdir); do
		if [ -d $srcdir/$i ]; then
			dealdir $srcdir/$i $dstdir/$i;
		else
			if ! $dirmade; then
				mkdir -p $dstdir && dirmade=true || {echo "Cannot make $dstdir" && continue};
			fi
			ln -sr $srcdir/$i $dstdir/$i;
		fi
	done
}

if [ -z $1 ]; then
	homedir=/tmp/home
else
	homedir=$1
fi
dealdir home $homedir;
