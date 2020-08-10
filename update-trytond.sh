#!/usr/bin/bash

source $HOME/.gnuhealthrc
/usr/bin/cp -rf GNUHEALTH/* ${GNUHEALTH_DIR}/tryton/server/modules
/usr/bin/cp -rf TRYTON/*    ${GNUHEALTH_DIR}/tryton/server/trytond-$TRYTON_VERSION/trytond/modules/

~/gnuhealth/tryton/server/trytond-5.0.25/bin/trytond-admin --all -d gnuhealth
