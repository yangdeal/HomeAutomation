MP4FOLDER="/mnt/dsm/97-motion-short-term"

CURRENTPWD=`pwd`

FOLDERS=(`find ${MP4FOLDER} -name Back -type d`)
echo ${#FOLDERS[*]}

# find ${MP4FOLDER} -name Back -type d | \
# while read DIR; do \
# echo "this is: " $DIR; \
# cd $DIR;\
# ls 2_201* | sort -R |tail -n +138;\
# cd $CURRENTPWD
# done
