#!/bin/sh

cd samples/

for sample in `ls .`; do
	echo "Building $sample"
	cd "$sample"
	lime build neko -Dnext -embed
	cd ..
done

cd ..
