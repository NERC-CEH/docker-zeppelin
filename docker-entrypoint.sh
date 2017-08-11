#!/bin/bash
echo "Startup script executing"
echo "SECRET_CONFIG - ${SECRET_CONFIG}"

if [[ -v SECRET_CONFIG ]]; then
  echo "Configuring Shiro config to use provided secret at ${SECRET_CONFIG}"
  
  ln -s ${SECRET_CONFIG} /opt/zeppelin/conf/shiro.ini
else
  echo "Using default Shiro configuration"
fi

echo $(ls)

./bin/zeppelin.sh run