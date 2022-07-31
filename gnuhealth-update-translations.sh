#!/bin/bash
source $HOME/.gnuhealthrc

LANGUAGE="zh_CN"
TRYTON_DATABASE="translations"
TRYTON_SERVER_DIR=${GNUHEALTH_DIR}/tryton/server
TRYTOND_ADMIN_CMD="${TRYTON_SERVER_DIR}/trytond-${TRYTON_VERSION}/bin/trytond-admin --email admin -d ${TRYTON_DATABASE} --all"

echo ""
echo "+-------------------------------------+"
echo "|   GNU Health 中文翻译文件导出工具   |"
echo "+-------------------------------------+"
echo ""

echo "## 正在创建 translation 数据库文件 ..."
dropdb --if-exists ${TRYTON_DATABASE} >/dev/null
createdb ${TRYTON_DATABASE}

echo "## 正在生成 admin 密码文件 ..."
password_file=$(mktemp -t gnuhealth-tempfile.XXXXXX)
echo "gnuhealth" > "${password_file}"
export TRYTONPASSFILE="${password_file}"

echo "## 正在运行 trytond-admin 命令升级数据库（1.初始化设置） ..."
${TRYTOND_ADMIN_CMD}

modules_ignored="('health_icd10pcs','health_icd11','health_genetics_uniprot')"
echo "## 正在使用 psql 激活所有模块，除了 $modules_ignored ..."
psql -q -c "UPDATE ir_module SET state = 'to activate' WHERE name NOT IN $modules_ignored" ${TRYTON_DATABASE}

echo "## 正在运行 trytond-admin 命令升级数据库（2.激活模块） ..."
${TRYTOND_ADMIN_CMD}
psql -q -c "UPDATE ir_translation SET value = ''" ${TRYTON_DATABASE}

echo "## 正在运行 trytond-admin 命令升级数据库（3.激活语言） ..."
${TRYTOND_ADMIN_CMD} --language ${LANGUAGE}

echo "## 正在导出 po 文件 ..."
python3 gnuhealth-translations-export.py --user admin --database ${TRYTON_DATABASE} --language ${LANGUAGE}
