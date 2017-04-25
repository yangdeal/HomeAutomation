IF="wlan0"

R1=`cat /sys/class/net/${IF}/statistics/rx_bytes`
T1=`cat /sys/class/net/${IF}/statistics/tx_bytes`
sleep 1
R2=`cat /sys/class/net/${IF}/statistics/rx_bytes`
T2=`cat /sys/class/net/${IF}/statistics/tx_bytes`
TBPS=`expr $T2 - $T1`
RBPS=`expr $R2 - $R1`
TKBPS=`expr $TBPS / 1024`
RKBPS=`expr $RBPS / 1024`
echo "tx ${IF}: $TBPS b/s rx ${IF}: $RBPS b/s"
echo "tx ${IF}: $TKBPS kb/s rx ${IF}: $RKBPS kb/s"

if [ ${RKBPS} -gt 1 ]
then
    echo all good, exit...
        exit 1
else
    echo lost connection, restarting mpc
fi

A=0
i=5
while [ $A -eq 0 ]
do
        /etc/init.d/mpd restart
        sleep 2

        mpc volume 20
        mpc load 3cw
        mpc play
        mpc repeat on

        mpc play 1
        logger reload mpd $i
        sleep $i
        A=`mpc current | grep 3CW | wc -l`
        i=`expr 2 \* $i`
        echo $i
        if [ $i -gt 600 ]
        then
                break
        fi
done
