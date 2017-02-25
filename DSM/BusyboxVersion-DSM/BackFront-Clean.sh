#! /bin/ash

# This is used to clean the back and front camera files based on below policies to save disk space
# back and front folders:
#   1. delete night files defined by from and to
#   2. leave random 10 files each day

# use: change CAMFOLDERROOT before run the script

## Parameters starts here
CAMFOLDERROOT="/volume1/Shared/97-motion-short-term"

BACKFOLDER="Back"
FRONTFOLDER="Front"
LIVINGROOMFOLDER="LivingRoom"

KEEPFILES="11"
DAYSAFTER="7"

# LIVINGROOMKEEPFILES="101"

## code starts here, do not modify
CURRENTPWD=`pwd`

## the files created between from and to will be deleted. This apply to all folders
from='210000' # From is later time, which is larger than "to". It must be in HHMMSS format, such as 210000
to='055959'   # To time, such as 050000

CAMFOLDER=${FRONTFOLDER}

for CAMFOLDER in ${BACKFOLDER} ${FRONTFOLDER} ; do
    FOLDERS=`find ${CAMFOLDERROOT} -mtime +${DAYSAFTER} -name ${CAMFOLDER} -type d`
    echo "+++++Total `echo ${FOLDERS} | wc -w` to procded for ${CAMFOLDER}"

    for FOLDER in ${FOLDERS}; do
        echo "  +++++Proceed forlder: ${FOLDER}"
        # read -p "$*"

        cd ${FOLDER}
        FILES=`find . -type f | grep mp4 | grep -v TimeLapse`
        echo "  +++++Total `echo ${FILES} | wc -w` files in the folder"

        # delete the files
        for file in ${FILES} ; do
            modified=$( stat "${file}"|grep Modify|cut -d" " -f 3 | cut -d'.' -f1 |sed s/\://g )
            # expect output in format: 18:46:33
            # echo "    ----Modified: ${modified}"

            # match late file
            if [[ ${from} -lt ${modified} ]] ; then
                if [[ ${modified} -lt "235959" ]] ; then
                    echo "    -----Matched night file: ${file}"
                    rm ${file}
                fi
            fi

            # match early file
            if [[ "000000" -lt ${modified} ]] ; then
                if [[ ${modified} -lt ${to} ]] ; then
                    echo "    -----Matched early file: ${file}"
                    rm ${file}
                fi
            fi
        done

        # keep random
        # complex to have random sort in busybox, since it do not have shut and sort -R. Finally found the way using awk
        FILES=`find . -type f | grep mp4 | grep -v TimeLapse | grep -vi keep | awk 'BEGIN{srand()}{printf "%06d %s\n", rand()*1000000, $0;}' | sort -n | cut -c8- | tail -n +${KEEPFILES}`
        for file in ${FILES} ; do
            echo "  -----File will be deleted: ${file}"
            rm ${file}
        done

    done # of each camera folder

done # of all camera folders

cd ${CURRENTPWD}