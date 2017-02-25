#kill -9 `ps |grep mpd|grep -v grep|cut -d" " -f 2`
#sleep 1
/etc/init.d/mpd restart
sleep 1
mpc load 3cw
mpc play

