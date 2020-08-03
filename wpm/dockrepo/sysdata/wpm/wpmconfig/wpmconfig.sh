#!/bin/bash
#
#  configuration for a secure db setup
#
########
                                                                                   VERSION="0.00.01"
#
# dependencies
ROOTPWD=root
WORKDIR="/opt/mysql/dbconfig/"
#
COMMAND=""
ROOT_PWD_OLD="root_pwd"
ROOT_PWD="GTH2020_quattro_marzo"
WPUSER="wpuser"
WPUSER_PWD="penna_matita_gomma"
WPDATABASE="gtlite"
GOTHINGSNET="10.133.%"
#
# constants
RED='\033[0;41;30m'
STD='\033[0;0;39m'
##
##########################################################################
avanti(){
  # Domanda di continuazione personalizzabile
  # call:    avanti $1
  #   $1:    "<stringa di domanda>"
  echo "----------------------------------------------------------------"
  read -rsp "$1" -n 1 key
  echo
}
#
##########################################################################
pause() {
#  Domanda 'continue or exit'
  avanti 'Press any key to continue or ^C to exit ...'
}
#
echo
echo
echo "---------------------------------------------------------"
echo
echo -e "This script will ${RED} RECONFIGURE ${STD} your database installation!"
echo "You should exec this script ONLY once and SOON AFTER"
echo "you create the MariaDB database"
echo
echo "Users now active:"
COMMAND="select host, user from mysql.user"
mysql -u root -p${ROOT_PWD_OLD} -e "${COMMAND}";
echo
pause
echo
echo "In the following we use the values in dbconfig.json"
echo "to configure the database service"
echo
echo "--> change root password, ..."
COMMAND="SET PASSWORD FOR root@localhost = PASSWORD('${ROOT_PWD}')"
mysql -u root -p${ROOT_PWD_OLD} -e "${COMMAND}";
sleep 0.5
echo "--> ... add root user from ip private network, ..."
COMMAND="CREATE USER 'root'@'${GOTHINGSNET}'";
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 0.5
echo "--> ... remove root user from public network '%', ..."
COMMAND="DROP USER 'root'@'%'";
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 0.5
echo "--> ... and verify result:"
COMMAND="select host, user from mysql.user"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 2
echo
echo "--> create database"
COMMAND="CREATE DATABASE ${WPDATABASE}"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 0.5
echo "--> ... and verify:"
COMMAND="show databases"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 2
echo
echo "--> create wp user"
COMMAND="GRANT ALL PRIVILEGES ON ${WPDATABASE}.* TO '${WPUSER}'@'localhost' IDENTIFIED BY '${WPUSER_PWD}'"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 0.5
echo "--> restrict access to IP private network"
COMMAND="GRANT ALL PRIVILEGES ON ${WPDATABASE}.* TO '${WPUSER}'@'${GOTHINGSNET}' IDENTIFIED BY '${WPUSER_PWD}'"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 0.5
echo "--> ... and verify result:"
COMMAND="select host, user from mysql.user"
mysql -u root -p${ROOT_PWD} -e "${COMMAND}";
sleep 2
echo
echo "Done."
echo
echo
echo "DISCLAIMER"
echo "Please note that this script is EXPERIMENTAL,"
echo "that is the configuration values are manually crafted"
echo 'into this script (i.e. the .json file is not read)'
echo
echo "Reading the dbconfig.json file will be performed"
echo "at the end of the experiments."
echo
