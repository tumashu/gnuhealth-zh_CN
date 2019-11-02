#!/bin/bash

scp -r ./GNUHEALTH/* gnuhealth@172.16.0.109:/home/gnuhealth/gnuhealth/tryton/server/modules/
scp -r ./TRYTON/* gnuhealth@172.16.0.109:/home/gnuhealth/gnuhealth/tryton/server/modules/
