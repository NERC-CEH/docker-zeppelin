#!/bin/bash
# Modified from the jupyter base-notebook start.sh script
# https://github.com/jupyter/docker-stacks/blob/master/base-notebook/start.sh

set -e

# If root user
if [ $(id -u) == 0 ] ; then
  # Only the username "datalab" was created in docker build, 
  # therefore rename "datalab" to $ZEPPELIN_USER
  usermod -d /home/$ZEPPELIN_USER -l $ZEPPELIN_USER datalab

  # Change UID of ZEPPELIN_USER to ZEPPELIN_UID if it does not match.
  if [ "$ZEPPELIN_UID" != $(id -u $ZEPPELIN_USER) ] ; then
    echo "Set user UID to: $ZEPPELIN_UID"
    usermod -u $ZEPPELIN_UID $ZEPPELIN_USER

    # Fix permissions for home and zeppelin directories
    for d in "$ZEPPELIN_HOME" "/home/$ZEPPELIN_USER"; do
      if [[ ! -z "$d" && -d "$d" ]]; then
        echo "Set ownership to uid $ZEPPELIN_UID: $d"
        chown -R $ZEPPELIN_UID "$d"
      fi
    done
  fi

  # Change GID of ZEPPELIN_USER to ZEPPELIN_GID, if given.
  if [ "$ZEPPELIN_GID" ] ; then
    echo "Change GID to $ZEPPELIN_GID"
    groupmod -g $ZEPPELIN_GID -o $(id -g -n $ZEPPELIN_USER)
  fi

  # Grant sudo permissions
  if [[ "$GRANT_SUDO" == "1" || "$GRANT_SUDO" == "yes" ]]; then
    echo "Granting $ZEPPELIN_USER sudo access"
    echo "$ZEPPELIN_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
  fi

  # Exec zeppelin docker-entrypoint as $ZEPPELIN_USER
  echo "Execute the command as $ZEPPELIN_USER"
  exec su $ZEPPELIN_USER -c "env PATH=$PATH $*"
else
if [[ ! -z "$ZEPPELIN_UID" && "$ZEPPELIN_UID" != "$(id -u)" ]]; then
  echo 'Container must be run as root to set $ZEPPELIN_UID'
fi
if [[ ! -z "$ZEPPELIN_GID" && "$ZEPPELIN_GID" != "$(id -g)" ]]; then
  echo 'Container must be run as root to set $ZEPPELIN_GID'
fi
if [[ "$GRANT_SUDO" == "1" || "$GRANT_SUDO" == "yes" ]]; then
  echo 'Container must be run as root to grant sudo permissions'
fi
  echo "Execute the command"
  exec $*
fi
