#!/bin/bash

if [ $2 ]
  then
    INIT=$2
else
   INIT="all"
fi

if [ $1 ]
  then
    if [ $1 != infinite -a $1 != disable -a $1 != enable ]
      then
        for (( i=1; i<=$1; i++ ))
        do
          if [ -f /usr/share/strobe/disable ]
          then
             echo "strobe disabled"
             break
          fi

          A=`cat /proc/acpi/button/lid/LID/state |sed -e 's/state:      open/open/g' | sed -e 's/state:      closed/closed/g'`

          if [ $A == closed ]
           then
             L=sleep
          fi

          if [ $A == open ]
           then
             L=$INIT
          fi




            if [ $L == all -o $L == light ]
              then
                echo on > /proc/acpi/ibm/light; 
            fi

            if  [ $L == all -o $L == power ]
              then
                echo 0 on > /proc/acpi/ibm/led;  #power led
            fi

            if  [ $L == all -o $L == sleep ]
              then
                echo 7 on > /proc/acpi/ibm/led;  #sleep led
            fi
            
            if [ $L == all -o $L == screen ]
              then
                echo 15 > /sys/class/backlight/acpi_video0/brightness 
            fi





            sleep 0.05




            if [ $L == all -o $L == light ]
              then
                echo off > /proc/acpi/ibm/light;
            fi

            if  [ $L == all -o $L == power ]
              then
                echo 0 off > /proc/acpi/ibm/led;  #power led
            fi

            if  [ $L == all -o $L == sleep ]
              then
                echo 7 off > /proc/acpi/ibm/led;  #sleep led
            fi

            if [ $L == all -o $L == screen ]
              then
                echo 0 > /sys/class/backlight/acpi_video0/brightness
            fi


            sleep 0.05

        done




    else

### run infinitely ###


      if [ $1 == infinite ]
        then
          echo "strobe running infinitely."
          echo "to exit, press [Ctrl+C]"
          for (( ;;  ))
          do
            if [ -f /usr/share/strobe/disable ]
            then
               echo "strobe disabled"
               break
            fi

            A=`cat /proc/acpi/button/lid/LID/state |sed -e 's/state:      open/open/g' | sed -e 's/state:      closed/closed/g'`
  
            if [ $A == closed ]
             then
               L=sleep
            fi
           
            if [ $A == open ]
             then
               L=$INIT
            fi


            if [ $L == all -o $L == light ]
              then
                echo on > /proc/acpi/ibm/light;
            fi

            if  [ $L == all -o $L == power ]
              then
                echo 0 on > /proc/acpi/ibm/led;  #power led
            fi
            
            if  [ $L == all -o $L == sleep ]
              then
                echo 7 on > /proc/acpi/ibm/led;  #sleep led
            fi

            if [ $L == all -o $L == screen ]
              then
                echo 15 > /sys/class/backlight/acpi_video0/brightness
            fi



            sleep 0.05


### turn off the leds  ###


            if [ $L == all -o $L == light ]
              then
                echo off > /proc/acpi/ibm/light;
            fi
 
            if  [ $L == all -o $L == power ]
              then
                echo 0 off > /proc/acpi/ibm/led;  #power led
            fi

            if  [ $L == all -o $L == sleep ]
              then
                echo 7 off > /proc/acpi/ibm/led;  #sleep led
            fi

            if [ $L == all -o $L == screen ]
              then
                echo 0 > /sys/class/backlight/acpi_video0/brightness
            fi


            sleep 0.05




            
          done    
      else
        if [ $1 == disable ]
          then   
            touch /usr/share/strobe/disable
            echo "strobe disabled"
        else 
          if [ $1 == enable ]
            then
              rm /usr/share/strobe/disable  
              echo "strobe enabled"
          fi
        fi
      fi
    fi
else
  echo "usage:  strobe [ <repititions> | infinite | disable | enable ]  <all | light | power | sleep | screen>  "
  echo "        to manually disable, touch /usr/share/strobe/disable"
  echo "        if no light is given, it defaults to all."
fi

echo 0 on > /proc/acpi/ibm/led;  #re initilize the power led
echo 15 > /sys/class/backlight/acpi_video0/brightness

