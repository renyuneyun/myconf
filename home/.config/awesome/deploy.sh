#!/bin/sh

srcdir=$1
dstdir=$2

if [ ! -d $dstdir ]; then
	mkdir $dstdir
fi

except=(deploy.sh third_party)

function can_deploy {
	local file="$1"
	for arr in ${except[@]}; do
		if [ "$file" = "$arr" ]; then
			return 1 #false
		fi
	done
	if [[ "$file" =~ \.bak$ ]] || [[ $file =~ \.old$ ]]; then
		return 1
	fi
	return 0 #true
}

for file in `ls`; do
	if can_deploy $file; then
		if [ -f $dstdir/$file ]; then
			rm $dstdir/$file
		fi
		ln -sr $file $dstdir/$file
	fi
done

