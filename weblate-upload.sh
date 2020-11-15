#!/usr/bin/bash

cd GNUHEALTH

# wlc upload gnu-health/health_archives/zh_Hans/  --overwrite -i health_archives/locale/zh_CN.po

for i in $(ls)
do
    echo "## Run command: wlc upload gnu-health/$i/zh_Hans/ --overwrite -i $i/locale/zh_CN.po"
    wlc upload gnu-health/$i/zh_Hans/ --overwrite --method translate -i $i/locale/zh_CN.po
done

