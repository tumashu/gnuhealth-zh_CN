#!/usr/bin/bash

/usr/bin/cp -rf GNUHEALTH/* ~/gnuhealth/tryton/server/modules
# /usr/bin/cp -rf TRYTON/*    ~/gnuhealth/tryton/server/trytond-5.0.25/trytond/modules/

~/gnuhealth/tryton/server/trytond-5.0.25/bin/trytond-admin --all -d gnuhealth
