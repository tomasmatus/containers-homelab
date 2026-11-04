#!/bin/bash

set -ue -o pipefail

POST_INSTALL_HOOKS_DIR=/docker-entrypoint-hooks.d/post-installation
NC_CONF_DIR=/var/www/html/config

# Copy the nextcloud config
cp ${POST_INSTALL_HOOKS_DIR}/custom.config.php ${NC_CONF_DIR}
