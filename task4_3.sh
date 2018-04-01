#!/usr/bin/env bash
# check parametrs
if [[ $# != 2 ]]
then
	echo "ERROR: For launch script need 2 parameters" 1>&2
	echo "1 - path to folder for which you need a backup" 1>&2
	echo "2 - quantity backup files" 1>&2
	exit 1
fi

src_dir="$1"
num_backup="$2"

#check backup dir
dst_dir="/tmp/backups/"
[ -d "/tmp" ] || mkdir /tmp
[ -d $dst_dir ] || mkdir /tmp/backups

#date form
date=$(date +'%F-%H%M%S%N')

#check first parametr
if [[ $src_dir != /* ]]
then
        echo "ERROR: Wrong path" 1>&2
        exit 1
fi

#check second parametr
if [[ -n $(echo $num_backup | grep -v '^[0-9][0-9]*$') ]];
then
        echo "$num_backup - bad parameter!" 1>&2
        exit 1
fi

#check directory or file for exist 
if [[ -d "$src_dir" || -f "$src_dir" ]]
then
#form file name and tar
	name=$(echo "$src_dir" | sed -r 's/^\/*//g' | sed -r 's/\/$//g' | sed 's/\/\/*/-/g')
#	echo "$name"
	dst_name=$(echo "$name"-"$date".tar.gz)
#	echo $dst_dir"_"$dst_name"_"$src_dir
	tar -czf "$dst_dir""$dst_name" "$src_dir" 2>/dev/null
else
	echo "ERROR: No such file or directory" 1>&2
	exit 1
fi
#remove old file
oldIFS=$IFS
delf=$(ls -sl | find "$dst_dir""$name"* | head -n -"$num_backup")
#echo $delf
IFS=$'\n'
for var in $delf
do
	rm -f "$var"
done
IFS=$oldIFS
