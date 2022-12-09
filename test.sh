#!/bin/bash
echo "----------------------------------------"

echo "[INFO] TEST SCRIPT"
echo ${1}
echo ${2}
echo ${3}

if [ "${1}" == "" ] ; then
  read -p 'Server Domain: ' serverDomain
else
  serverDomain=${1}
fi

if [ "${2}" == "" ] ; then
  read -sp 'Server Password: ' serverPassword
else
  serverPassword=${2}
fi

/bin/bash test2.sh $serverDomain $serverPassword

echo "[INFO] Setup done"