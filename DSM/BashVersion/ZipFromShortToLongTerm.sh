#! /bin/bash

# This is to zip and clean the short term folder
#   1. zip the short term folder which is DAYSAFTER days older to long term, 
#   2. and clean up the old folder

# folder structure:
# /mnt/dsm/97-motion-short-term/2015/201509/20150930/iSpy/video/

## Parameters starts here
MOUNTPOINT="/mnt/dsm"
SHORTTERMFOLDER="97-motion-short-term"
SHORTTERMROOT="${MOUNTPOINT}/${SHORTTERMFOLDER}"
LONGTERMROOT="${MOUNTPOINT}/98-motion-long-term"
# LONGTERMROOT="${MOUNTPOINT}/a/test"
RECYCLEBIN="${MOUNTPOINT}/#recycle"

DAYSAFTER="7"


## code starts here, do not modify
# find /mnt/dsm/97-motion-short-term -mindepth 2 -maxdepth 2 -mtime +${DAYSAFTER} -type d | sort

FOLDERS=(`cd ${SHORTTERMROOT}; find . -mindepth 3 -maxdepth 3 -mtime +${DAYSAFTER} -type d | sort |cut -c3-`)
# get the folders name in format link "2017/201702/20170210", whichout first 2 chars "./"
echo "+++++Total ${#FOLDERS[*]} to proceed"

for FOLDER in "${FOLDERS[@]}"; do
    echo "  +++++Proceed forlder: ${FOLDER}"
    SUBFOLDER12=`echo ${FOLDER} | cut -d"/" -f 1-2`
    SUBFOLDER3=`echo ${FOLDER} | cut -d"/" -f 3`
    # SUBFOLDER3 is the last part of the folder name, will generate the zip file with same name

    # goto the folder and zip to avoid folder name included in the zip file
    cd ${SHORTTERMROOT}/${SUBFOLDER12}
    mkdir -p ${LONGTERMROOT}/${SUBFOLDER12}
    zip -r ${LONGTERMROOT}/${SUBFOLDER12}/${SUBFOLDER3}.zip ${SUBFOLDER3}

    # move the short term folder to recycle bin in DSM. It will keep few days (7 days current setting) before final remove by DSM policy
    echo "Moving ${SHORTTERMROOT}/${SUBFOLDER12}/${SUBFOLDER3} to recycle bin"
    mkdir -p ${RECYCLEBIN}/${SHORTTERMFOLDER}/${SUBFOLDER12}
    mv ${SHORTTERMROOT}/${SUBFOLDER12}/${SUBFOLDER3} ${RECYCLEBIN}/${SHORTTERMFOLDER}/${SUBFOLDER12}
    # read -p "$*"
done

echo "+++++Total ${#FOLDERS[*]} proceeded"
