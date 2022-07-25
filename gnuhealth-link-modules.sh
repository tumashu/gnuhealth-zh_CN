
DEV_DIR=/home/feng/projects/gnuhealth/tryton/
INSTALL_DIR=/home/feng/gnuhealth/tryton/server/modules/

for i in $(ls ${DEV_DIR} | grep ^health)
do
    echo "## Run command: ln -s ${DEV_DIR}/${i} ${INSTALL_DIR}"
    ln -s ${DEV_DIR}${i} ${INSTALL_DIR}
done
