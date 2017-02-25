# This is used to rotate iSpy folder to short term folder every midnigh, running from DSM schedule.

############ iSpy folder archived to a daily folder ##############

Archieved_base=/volume1/Shared/97-motion-short-term
Video=/volume1/Shared/96-iSpy

Yesterday_DIR=$Archieved_base/`date -d -1 +%Y`/`date -d -1 +%Y%m`/`date -d -1 +%Y%m%d`/iSpy
mkdir -p $Yesterday_DIR

cd $Video
mv * $Yesterday_DIR

########## iRecorder folder archived to a daily folder###########
#copy from source folder since rsync will sync the data from vps. rsync will delete old files
#########################################
#Archieved_base=/mnt/sda1/transmission/97-motion-short-term
#LastiRecorder=/mnt/sda1/transmission/01-motion/04-audiorecord/`date -d $Yesterday +%Y`/`date -d $Yesterday +%Y%m`/`date -d $Yesterday +%Y%m%d`

#Yesterday_DIR=$Archieved_base/`date -d $Yesterday +%Y`/`date -d $Yesterday +%Y%m`/`date -d $Yesterday +%Y%m%d`/iRecorder
#mkdir -p $Yesterday_DIR

#cd $LastiRecorder
#cp * $Yesterday_DIR

