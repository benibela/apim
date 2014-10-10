#/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../../../manageUtils.sh

mirroredProject apim

BASE=$HGROOT/programs/system/APIV

case "$1" in
mirror)
  syncHg  
;;

esac

