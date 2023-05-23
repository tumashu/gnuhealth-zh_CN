#!/bin/bash

source $HOME/.gnuhealthrc

LANGUAGE="zh_CN"
TRYTON_DATABASE="translations"
TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server

echo "## 正在从 weblate.org 获取最新 gnuhealth 翻译 ..."
${TRYTON_SERVER_DIR}/util/gnuhealth-control getlang ${LANGUAGE}

echo "## 正在升级 gnuhealth 所有模块 ..." 
${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --email admin -d ${TRYTON_DATABASE} --all
