#!/usr/bin/zsh

repo_dir=`pwd`

function dealdir {
	local curdir="`pwd`";
	local srcdir=$1;
	local dstdir=$2;
	local dirmade=false;
	cd $srcdir;
	if [ `pwd` != $repo_dir ]; then
		if [ -f deploy.sh ]; then
			sh deploy.sh $1 $2;
			return;
		fi
	fi
	for i in $(ls -A); do
		if [ -d $i ]; then
			dealdir $i $dstdir/$i;
		else
			if ! $dirmade; then
				mkdir -p $dstdir && dirmade=true || {echo "Cannot make $dstdir" && continue};
			fi
			if [ -L $dstdir/$i ]; then
				rm $dstdir/$i;
			fi
			ln -sr $i $dstdir/$i;
		fi
	done
	cd "$curdir";
}

if [ -z $1 ]; then
	homedir=/tmp/home
else
	homedir=$1
fi

git submodule init
git submodule update &
dealdir home $homedir;

wait

