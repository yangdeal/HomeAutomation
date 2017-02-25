cd /root
TEMP_Inside=`digitemp_DS9097 -t0 -q | grep -i sensor | awk '{print $7}'`
TEMP_Outside=`digitemp_DS9097 -t1 -q | grep -i sensor | awk '{print $7}'`
DATE=`date +%Y-%m-%d`
TIME=`date +%H:%M:%S`


echo $TEMP_Inside > /tmp/inside.html
echo $TEMP_Outside > /tmp/outside.html

#sed "s/.*Inside.*/Inside:${TEMP_Inside}/;s/.*Outside.*/Outside:NA/;s/.*Date.*/Date:${DATE}/;s/.*Time.*/Time:${TIME}/" /tmp/temperature.html > /tmp/t.html
sed "s/.*Inside.*/Inside:${TEMP_Inside}/;s/.*Outside.*/Outside:${TEMP_Outside}/;s/.*Date.*/Date:${DATE}/;s/.*Time.*/Time:${TIME}/" /tmp/temperature.html > /tmp/t.html
cp /tmp/t.html /tmp/temperature.html

wget -O /tmp/wget_log "http://ydealvps.haoyucun.com/tomatoinput.php?file=digitemp_tina&value=$TEMP_Inside"
wget -O /tmp/wget_log "http://ydealvps.haoyucun.com/tomatoinput.php?file=digitemp_outdoor&value=$TEMP_Outside"
