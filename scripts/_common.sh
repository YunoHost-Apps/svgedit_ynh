#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="wget"

# App package root directory should be the parent folder
PKG_DIR=$(cd ../; pwd)

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

ynh_configure () {
    local TEMPLATE=$1
    local DEST=$2
    type j2 2>/dev/null || sudo pip install j2cli
    j2 "${PKG_DIR}/conf/$TEMPLATE.j2" > "${PKG_DIR}/conf/$TEMPLATE"
    ynh_backup_if_checksum_is_different "$DEST"
    sudo cp "${PKG_DIR}/conf/$TEMPLATE" "$DEST"
    ynh_store_file_checksum "$DEST"
    sudo chown root: "$DEST"
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
