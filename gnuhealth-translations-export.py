#  gnuhealth_translations-export.py
#  
#  Copyright 2017 Luis Falcon <falcon@gnuhealth.org>
#  Copyright 2011-2022 GNU Solidario <health@gnusolidario.org>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
# How to use this tool?
# 1. Install gnuhealth from hg repo.
# 2. Active all health modules.
# 3. Active language which will export.
# 4. Clean up translation and sync translation.
# 5. Edit config variables in this script.
# 6. Run this script.

import sys
import os

from proteus import config, Model, Wizard

## User need edit the below variables before run this script.
hostname        =  'localhost'
port            =  '8000'
user            =  'admin'
password        =  'gnuhealth'
dbname          =  'gnuhealth1'
language        =  'zh_CN'
export_root_dir =  '~/projects/gnuhealth-zh_CN/GNUHEALTH'
## ---------------------------------------------------------

def main():
    connect_health_server()
    export_all_translations()

def connect_health_server():
    print("Connecting to GNU Health Server ...")
    health_server = 'http://'+user+':'+password+'@'+hostname+':'+port+'/'+dbname+'/'
    conf = config.set_xmlrpc(health_server)
    print("GNU Health Server is connected!")
 
def export_all_translations():
    print("Starting export {0} translations of gnuhealth modules ...".format(language))
    for module in get_all_health_module_names():
        po_file = get_po_file_path(module)
        print("## Exporting to '{0}'".format(po_file))
        export_translation(language, module, po_file)
    print("Finish to export!")

def get_all_health_module_names():
    Module = Model.get('ir.module')
    modules = Module.find([('name', 'like', "health%"),
                           ('state', 'in', ['activated', 'to upgrade', 'to remove'])])
    return [module.name for module in modules]
    
def get_po_file_path(module_name):
    path = export_root_dir + "/" + module_name + "/locale/zh_CN.po"
    return os.path.expanduser(path)

def export_translation(lang, module, po_file):
    Lang = Model.get('ir.lang')
    Module = Model.get('ir.module')
    translation_export = Wizard('ir.translation.export')
    translation_export.form.language, = Lang.find([('code', '=', lang)])
    translation_export.form.module, = Module.find([('name', '=', module)])
    translation_export.execute('export')
    data = translation_export.form.file
    if data is None:
        print("   WARN: Module {0} have no translation for languate {1}.\n".format(module, lang))
    else:
        os.makedirs(os.path.dirname(po_file), exist_ok=True)
        with open(po_file, 'wb') as binary_file:
            binary_file.write(translation_export.form.file)
    translation_export.execute('end')

main()