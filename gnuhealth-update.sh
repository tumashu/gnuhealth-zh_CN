#!/usr/bin/bash

source $HOME/.gnuhealthrc

TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server

echo "## Copy health-* translation files."
/usr/bin/cp -rf GNUHEALTH/* ${TRYTON_SERVER_DIR}/modules

TRYTON_DIR=$(pwd)/TRYTON

cd ${TRYTON_DIR}
for i in $(ls)         
do  
    echo "## copy $i translation file."
    cd ${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/trytond/modules/$i/
    /usr/bin/cp -rf ${TRYTON_DIR}/${i}/*  ./;
done  

echo "## Run trytond-admin --all -d gnuhealth"
${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --all --language zh_CN -d gnuhealth
