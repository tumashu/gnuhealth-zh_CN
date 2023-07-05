#!/bin/bash
source $HOME/.gnuhealthrc

help()
{
    cat << EOF

GNU Health HMIS po files export tool

usage: `basename $0` language

    Example:
    $ bash ./gnuhealth-update-translations.sh zh_CN

EOF
    exit 0
}

if [ $# -eq 0 ]; then
    help
fi

LANGUAGE=$1
TRYTON_DATABASE="mytmpdb"
TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server
TRYTOND_ADMIN_CMD="${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --email admin -d ${TRYTON_DATABASE} --all"

echo ""
echo "+--------------------------------------------+"
echo "|    GNU Health HMIS po files export tool    |"
echo "+--------------------------------------------+"
echo ""

echo "## Creating database '${TRYTON_DATABASE}' ..."
dropdb --if-exists ${TRYTON_DATABASE} >/dev/null
createdb ${TRYTON_DATABASE}

echo "## Creating admin password file ..."
password_file=$(mktemp -t gnuhealth-tempfile.XXXXXX)
echo "gnuhealth" > "${password_file}"
export TRYTONPASSFILE="${password_file}"

echo "## Running trytond-admin command to update DB (1. Init setup) ..."
${TRYTOND_ADMIN_CMD}

modules_ignored="('health_icd10pcs','health_icd11')"
echo "## Active all modules with psql command，except $modules_ignored ..."
psql -q -c "UPDATE ir_module SET state = 'to activate' WHERE name NOT IN $modules_ignored" ${TRYTON_DATABASE}

echo "## Running trytond-admin command to update DB (2. Active modules) ..."
${TRYTOND_ADMIN_CMD}
psql -q -c "UPDATE ir_translation SET value = ''" ${TRYTON_DATABASE}

echo "## Running trytond-admin command to update DB (3. Active language) ..."
${TRYTOND_ADMIN_CMD} --language ${LANGUAGE}

echo "## Export po files ..."
python3 gnuhealth-translations-export.py --user admin --database ${TRYTON_DATABASE} --language ${LANGUAGE}
