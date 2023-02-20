#!/bin/bash

tree_dir=``
pwd=`pwd`
for file in $(ls -a | grep -i ".x"); do
	if [ -h ~/$file ]
		then
			echo "链接~/$file 已存在"
			rm ~/$file
			# continue
	fi
	ln -s  $pwd/$file ~/$file
done
