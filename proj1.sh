#!/bin/bash

listit(){
	local local_dir=$1
	# search path for subdirectories
	local currpath
	for currpath in `find "$local_dir" -maxdepth 1 -mindepth 1 -type d| sort 2>/dev/null`; do
                local path=`basename "$currpath"`
		# print directory
                echo "  <LI>$path</LI>" >> $2
                echo "  <UL>" >> $2
		# if directory has subdirectories, recusrively call listit
		if [ "$(ls -d $local_dir)" ]; then
			#echo "$local_dir contains subdirectories, checking $currpath"
			listit $currpath $2
		fi
		# search path for files
                local currfile
		for currfile in `find "$currpath" -maxdepth 1 -mindepth 1 -type f| sort 2>/dev/null`; do
                        #echo "found file $currfile"
			local file=`basename "$currfile"`
			echo "    <LI><a href="$currfile">$file</a></LI>" >> $2
                done
                echo "  </UL>" >> $2
        done
}

# check for the correct number of args
if [ "$#" == "2" ]; then
	# check for read permissions
	if [ -r $1 ]; then
		i=0
		dir=$1
		outfile=$2
		echo "<UL>" > $2
		listit "$dir" "$outfile"
		echo "</UL>" >> $2
	else
		echo "ERROR, cannot read directory given"
	fi
else
	echo "ERROR, invalid number of arguments."
	echo "The correct number of arguments is 2, $# arguments have been entered."
fi
