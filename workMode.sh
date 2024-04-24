#! /usr/bin/bash

ENV_VAULT=${HOME}/.env_vault

if [ -z "${LDAP_USER}" ]; then
    echo "ENV-Variables not set"
    source <(ansible-vault view ${ENV_VAULT})
  else
    echo "Variables are set! Login with user=${LDAP_USER}"
  fi

echo "Starting OpenVPN daemon"
sudo bash -c 'openvpn --config Documents/Work/gw02-UDP4-1195-lungmuss-config.ovpn --auth-user-pass <(echo -e "'"${LDAP_USER}"'\n'"${LDAP_PW}"'") --daemon'


