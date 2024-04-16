#!/bin/bash
# copy back files in "/" to git/tree under tree/
set -euo pipefail

cd `dirname $0`
cd tree
for i in `find . -type f|sort`
do
	source="/$i"
	[ -f "$source" ] || {
		echo "WARN: '$source' is not file or not readable - ignored." >&2
		continue
	}
	diff -u "$i" "$source" || {
		echo -n "Copy back $source -> $i [yN]? "
		read ans
		if [[ $ans =~ ^[yY]$ ]]; then
			cp -v $source $i
		fi
	}
done
exit 0
