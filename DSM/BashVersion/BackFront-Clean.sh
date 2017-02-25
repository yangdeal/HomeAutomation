#! /bin/bash

# This is used to clean the back and front camera files based on below policies to save disk space
# back and front folders:
#   1. delete night files defined by from and to
#   2. leave random 10 files each day

# use: change CAMFOLDERROOT before run the script

## Parameters starts here
CAMFOLDERROOT="/mnt/dsm/97-motion-short-term/2015"

BACKFOLDER="Back"
FRONTFOLDER="Front"
LIVINGROOMFOLDER="LivingRoom"

KEEPFILES="11"
# LIVINGROOMKEEPFILES="101"

## code starts here, do not modify
CURRENTPWD=`pwd`

## the files created between from and to will be deleted. This apply to all folders
from='21:00:00' # From is later time, which is larger than "to". such as 21:00:00
to='05:59:59'   # To time, such as 05:00:00

for CAMFOLDER in ${BACKFOLDER} ${FRONTFOLDER} ; do
    FOLDERS=(`find ${CAMFOLDERROOT} -name ${CAMFOLDER} -type d`)
    echo "+++++Total ${#FOLDERS[*]} to procded for ${CAMFOLDER}"

    for FOLDER in "${FOLDERS[@]}"; do
        echo "  +++++Proceed forlder: ${FOLDER}"
        # read -p "$*"

        cd ${FOLDER}
        FILES=(`find . -type f | grep mp4 | grep -v TimeLapse`)
        echo "  +++++Total ${#FILES[*]} files in the folder"

        for file in "${FILES[@]}" ; do
            modified=$( stat -c%y "${file}" | cut -d' ' -f2 | cut -d'.' -f1 )
            # echo "    ----Modified: ${modified}"
            if [[ (${from} < ${modified} && ${modified} < "23:59:59") || ("00:00:00" < ${modified} && ${modified} < ${to}) ]] ; then
            # if [[ (${from} < ${modified} && ${modified} < "23:59:59") ]] ; then
                echo "    -----Matched night file: ${file}"
                rm ${file}
            fi
        done

        # keep random
        FILES=(`find . -type f | grep mp4 | grep -v TimeLapse | grep -v keep | sort -R | tail -n +${KEEPFILES}`)
        for file in "${FILES[@]}" ; do
            echo "  -----File will be deleted: ${file}"
            rm ${file}
        done

    done # of each camera folder

done # of all camera folders

cd ${CURRENTPWD}