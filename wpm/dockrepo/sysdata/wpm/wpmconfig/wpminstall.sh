#!/bin/bash
#
#  Here you should find a real config script for your wordpress installation
#
########
#
#  simulation of a config bash script
#
#  User responds yes/no to simulate a real config script
#
#  scope:  verify logic in the calling program
#
########
                                                                                   VERSION="0.00.01"
#
# dependencies
#
#   adjusted from the generic version to wp installation
#
#
#######
ROOTPWD=boh
WORKDIR="dockrepo/sysdata/wp/wpconfig"
#
COMMAND=""
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
echo "----------------------------------------------- WPINSTALL"
echo
echo -e "   ${RED}  Please note: this is a SIMULATION  ${STD}"
echo -e "   ${RED}    you choose success or failure    ${STD}"
echo
echo "---------------------------------------------------------"
echo
echo "Please respond y/Y to simulate SUCCESS, any key fo FAILURE"
echo
read -rsp "Should I succeed ? [y/N] " -n 1 key
case "$key" in
  [yY])  # OK, si va avanti
    echo
    echo "  OK, I will succeed"
    RETVALUE=0
    ;;
  *)
    echo
    echo "  OK, I'm failing"
    RETVALUE=81
    ;;
esac
echo ${RETVALUE}
