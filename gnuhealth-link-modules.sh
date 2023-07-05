
DEV_DIR=/home/feng/projects/health/tryton/
INSTALL_DIR=/home/feng/gnuhealth/tryton/server/modules/

for i in $(ls ${DEV_DIR} | grep ^health)
do
    rm -rf ${INSTALL_DIR}/${i}
    echo "## Run command: ln -s ${DEV_DIR}/${i} ${INSTALL_DIR}"
    ln -s ${DEV_DIR}${i} ${INSTALL_DIR}
done
