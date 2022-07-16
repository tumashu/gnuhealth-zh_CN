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
hostname  =  'localhost'
port      =  '8000'
user      =  'admin'
password  =  'gnuhealth'
dbname    =  'gnuhealth1'

directory =  '/home/feng/projects/gnuhealth-zh_CN/GNUHEALTH/'
language  =  'zh_CN'

def main():
    connect_health_server()
    export_all_translations()

def connect_health_server():
    health_server = 'http://'+user+':'+password+'@'+hostname+':'+port+'/'+dbname+'/'
    print ("Connecting to GNU Health Server ...")
    conf = config.set_xmlrpc(health_server)
    print ("Connected !")
 
def export_all_translations():
    for module in get_all_health_module_names():
        print("## Export {0} language of module {1}".format(language, module))
        po_file = get_po_file_path(module)
        export_translation(language, module, po_file)

def get_all_health_module_names():
    Module = Model.get('ir.module')
    modules = Module.find([('name', 'like', "health%"),
                           ('state', 'in', ['activated', 'to upgrade', 'to remove'])])
    return [module.name for module in modules]
    
def get_po_file_path(module_name):
    return directory + module_name + "/locale/zh_CN.po"

def export_translation(lang, module, po_file):
    Lang = Model.get('ir.lang')
    Module = Model.get('ir.module')
    translation_export = Wizard('ir.translation.export')
    translation_export.form.language, = Lang.find([('code', '=', lang)])
    translation_export.form.module, = Module.find([('name', '=', module)])
    translation_export.execute('export')
    data = translation_export.form.file
    if data is None:
        print("   Note: Module {0} have no translation for languate {1}.".format(module, lang))
    else:
        os.makedirs(os.path.dirname(po_file), exist_ok=True)
        with open(po_file, 'wb') as binary_file:
            binary_file.write(translation_export.form.file)
    translation_export.execute('end')

main()
