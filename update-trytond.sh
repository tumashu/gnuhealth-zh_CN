#!/usr/bin/bash

source $HOME/.gnuhealthrc

TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server

/usr/bin/cp -rf GNUHEALTH/* ${TRYTON_SERVER_DIR}/modules
/usr/bin/cp -rf TRYTON/*    ${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/trytond/modules/

${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --all -d gnuhealth
