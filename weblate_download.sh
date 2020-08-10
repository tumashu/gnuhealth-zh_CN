#!/usr/bin/bash

cd GNUHEALTH

for i in $(ls)
do  
    echo "## Run command: wlc download gnu-health/$i/zh_Hans/ -o $i/locale/zh_CN.po"
    wlc download gnu-health/$i/zh_Hans/ -o $i/locale/zh_CN.po
done  
