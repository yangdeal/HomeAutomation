#! /bin/bash

# back and front folders, after 15 days:
#   1. delete night files defined by from and to
#   2. leave random 10 files each day

BACKFOLDER="Back"
FRONTFOLDER="Front"
LIVINGROOMFOLDER="LivingRoom"


CAMFOLDERROOT="/mnt/dsm/97-motion-short-term/2015"

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

        # keep rand
        FILES=(`find . -type f | grep mp4 | grep -v TimeLapse | sort -R | tail -n +11`)
        for file in "${FILES[@]}" ; do
            echo "  -----File will be deleted: ${file}"
            rm ${file}
        done

    done # of each camera folder

done # of all camera folders

cd ${CURRENTPWD}