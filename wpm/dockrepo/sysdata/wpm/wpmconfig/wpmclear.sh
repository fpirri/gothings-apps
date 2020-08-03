#!/bin/bash
#
                                                                                   VERSION="0.00.03"
#######
#
#  AZZERAMENTO completo di una installazione wordpress
#
########
#
#  Richiamato da gocloud-wp
#
#  - si esegue una copia del db gtlite su gtlite_bk
#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress in gtlite
#  - si rileggono i file di configurazione wpinit.json e wpinstall.json da github
#      <-- per il momento NON si legge wpexpand.json per non usare wpdirs.tar.gz
#          in fase di sviluppo
#
##########################################################################
# configurazione automatica                                                                  ANCORA DA FARE
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
#
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
##########################################################################
dots(){
  # wait $1 seconds, printing dots on the screen
  #   $1 :  # of seconds to wait
  local param1
  printf -v param1 '%d\n' $1 2>/dev/null # converti in intero con tutti i controlli
  while [ $param1 -gt 0 ]
  do
    echo -n "."
    sleep 0.5
    echo -n "."
    sleep 0.5
    let "--param1"
  done
}
#
##########################################################################
# make a copy of db
backupdb(){
#
#//  https://www.matteomattei.com/how-to-clone-mysql-database-schema-in-php/
#//    <--  usata com template ..
#//    <--  problemi con l'utente wpuser su gtlite_bk
#//         <-- utente root remoto non ha GRANT
#//    <--  versione cli: thanks to Richard Maurer
#
  curl --verbose 'http://www.gothings.org/go_creadb_bk.php'
#  - si esegue una copia del db gtlite su gtlite_bk

  echo "backup db DA FARE !"
}
#
##########################################################################
delwpfiles(){
#
#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress in gtlite
#  - si rileggono i file di configurazione wpinit.json e wpinstall.json da github
#      <-- per il momento NON si legge wpexpand.json per non usare wpdirs.tar.gz
#          in fase di sviluppo

#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress in gtlite
#  - si rileggono i file di configurazione wpinit.json e wpinstall.json da github
#      <-- per il momento NON si legge wpexpand.json per non usare wpdirs.tar.gz
#          in fase di sviluppo

echo
echo "     <-- delete wordpress dirs"
echo "     <-- wp-admin"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-admin
echo "     <-- wp-includes"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-includes
echo "     <-- wp-content"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-content
echo
echo "     <-- delete wordpress files"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-*
#
#  rimangono:    index.php   license.txt   xmlrpc.php   readme.html   .htaccess
#                30/11/2017   01/01/2019   01/07/2019   02/09/2019    18/02/2020

}
#
##########################################################################
#                                                         CLEAR OPERATIONS
echo
echo
echo "--------------------------------------------------------- wpclear v$VERSION"
echo
echo "          Wordpress CLEAR function"
echo "This function will COMPLETELY REMOVE wordpress from"
echo "database and will delete ALL wordpress files"
echo
echo -e "  ${RED}  This operation in NOT RECOVERABLE !!!   ${STD}"
echo -e "  ${RED}                                          ${STD}"
echo
echo "---------------------------------------------------------"
echo
echo "Please note:"
echo "this is your last chance to NOT DESTROY your wordpress installation!"
echo
echo "Please note also: I will ask for your sudo password"
read -rsp "Do you like to CLEAR ? [y/N] " -n 1 key
case "$key" in
  [yY]) 
      backupdb
      if [ ${RETVALUE} -eq 0 ]; then
        deletedb
      fi
      if [ ${RETVALUE} -eq 0 ]; then
        delwpfiles
      fi
      ;;
    *)
      echo
      echo
      echo "CLEAR operation NOT performed"
      dots 2
      RETVALUE=0
      ;;
esac
echo ${RETVALUE}
