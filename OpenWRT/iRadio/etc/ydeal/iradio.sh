/etc/init.d/mpd restart
sleep 2

mpc volume 20
mpc load 3cw
mpc play
mpc repeat on

sleep 2
A=`mpc current | grep 3CW | wc -l`
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

#while [ `df |grep mnt|wc -l` -eq 0 ]
#do
#  mount -t cifs '\\192.168.21.151\Audio' /mnt -o user=username,password=password
#  logger looping while no nas mount
#  sleep 5
#done


