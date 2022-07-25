#!/usr/bin/bash

source $HOME/.gnuhealthrc

TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server

echo "## Copy health-* translation files."
/usr/bin/cp -rf GNUHEALTH/* ${TRYTON_SERVER_DIR}/modules

echo "## Run trytond-admin --all --language zh_CN -d gnuhealth"
${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --all --language zh_CN -d ghdemo40
