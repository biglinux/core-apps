# !adjust-swappiness.sh
# Written By F. Goncalves @ Softelabs.com on 06 May 2010
#
# will adjust the current swappiness of the kernel
# based on the idea by Con Kolivas (http://kerneltrap.org/node/1044)
#
result=0
resultant=0
echo " $(date) - Starting Adjusting Swappiness according memload"
#
total=$(grep MemTotal /proc/meminfo | awk '{ print $2 }')       # obtain tot memory
#
while [ true ]; do
#
  used=$(grep AnonPages /proc/meminfo | awk '{ print $2 }')     # get used memory
  result=$(echo $used \* 100 / $total | bc -q)                            # compute usage in %
#  if $result -ne $resultant ;
#  then
     echo $result > /proc/sys/vm/swappiness                             # adjust it please
     echo "$(date) - Now Adjusting Swappiness to $result"
#     resultant=$result
#  fi
#
sleep 2
#
done
#
# Will stay here forever ..... hi...hi...hi....
#