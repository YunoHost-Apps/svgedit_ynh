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
ynh_set_default_perm () {
    local DIRECTORY=$1
    local user=$YNH_APP_INSTANCE_NAME
    id -u $user 2>/dev/null || user=root
    # Set permissions
    chown -R $user:www-data $DIRECTORY
    chmod -R 440 $DIRECTORY
    find $DIRECTORY -type d -print0 | xargs -0 chmod 550 \
        || echo "No file to modify"

}
ynh_export () {
    local ynh_arg=""
    for var in $@;
    do
        ynh_arg=$(echo $var | awk '{print toupper($0)}')
        if [ "$var" == "path_url" ]; then
            ynh_arg="PATH"
        fi
        ynh_arg="YNH_APP_ARG_$ynh_arg"
        export $var=${!ynh_arg}
    done
}
ynh_get_and_export () {
    local ynh_arg=""
    for var in $@;
    do
        ynh_arg=$var
        if [ "$var" == "path_url" ]; then
            ynh_arg="path"
        fi
        export $var=$(ynh_app_setting_get $app $ynh_arg)
    done
}

# Check the path doesn't exist
# usage: ynh_final_path_available PATH
ynh_final_path_available () {
    if [ -e "$final_path" ]
    then
        ynh_die "This path '$final_path' already contains a folder"
    fi
}

# Save listed var in YunoHost app settings 
# usage: ynh_save_args VARNAME1 [VARNAME2 [...]]
ynh_save_args () {
    for var in $@;
    do
        local setting_var="$var"
        if [ "$var" == "path_url" ]; then
            setting_var="path"
        fi
        ynh_app_setting_set $app $setting_var ${!var}
    done
}
ynh_sso_access () {
    ynh_app_setting_set $app unprotected_uris "/"

    if [[ $is_public -eq 0 ]]; then
        ynh_app_setting_set $app protected_uris "$1"
    fi
    yunohost app ssowatconf
}

ynh_exit_if_up_to_date () {
    if [ "${version}" = "${last_version}" ]; then
        info "Up-to-date, nothing to do"
        ynh_die "Up-to-date, nothing to do" 0
    fi
}

log() {
  echo "${1}"
}

info() {
  log "[INFO] ${1}"
}

warn() {
  log "[WARN] ${1}"
}

err() {
  log "[ERR] ${1}"
}

to_logs() {

  # When yunohost --verbose or bash -x
  if $_ISVERBOSE; then
    cat
  else
    cat > /dev/null
  fi
}

ynh_read_json () {
    sudo python3 -c "import sys, json;print(json.load(open('$1'))['$2'])"
}


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


# Exit without error if the package is up to date
#
# This helper should be used to avoid an upgrade of a package
# when it's not needed.
#
# To force an upgrade, even if the package is up to date,
# you have to set the variable YNH_FORCE_UPGRADE before.
# example: sudo YNH_FORCE_UPGRADE=1 yunohost app upgrade MyApp
#
# usage: ynh_abort_if_up_to_date
ynh_abort_if_up_to_date () {
    local force_upgrade=${YNH_FORCE_UPGRADE:-0}
    local package_check=${PACKAGE_CHECK_EXEC:-0}

    local version=$(ynh_read_json "/etc/yunohost/apps/$YNH_APP_INSTANCE_NAME/manifest.json" "version" || echo 1.0)
    local last_version=$(ynh_read_manifest "version" || echo 1.0)
    if [ "$version" = "$last_version" ]
    then
        if [ "$force_upgrade" != "0" ]
        then
            echo "Upgrade forced by YNH_FORCE_UPGRADE." >&2
            unset YNH_FORCE_UPGRADE
        elif [ "$package_check" != "0" ]
        then
            echo "Upgrade forced for package check." >&2
        else
            ynh_die "Up-to-date, nothing to do" 0
        fi
    fi
}


ynh_version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# In upgrade script allow to test if the app is less than or equal a specific version
#
# usage: ynh_version_le "0.5"
ynh_version_le() {
    local version=$(ynh_read_json "/etc/yunohost/apps/$YNH_APP_INSTANCE_NAME/manifest.json" "version" || echo 1.0)
    ynh_version_gt "$1" "${version}"
}

ynh_debian_release () {
    lsb_release --codename --short
}

is_stretch () {
    if [ "$(ynh_debian_release)" == "stretch" ]
    then
        return 0
    else
        return 1
    fi
}

is_jessie () {
    if [ "$(ynh_debian_release)" == "jessie" ]
    then
        return 0
    else
        return 1
    fi
}

# Reload (or other actions) a service and print a log in case of failure.
#
# usage: ynh_system_reload service_name [action]
# | arg: service_name - Name of the service to reload
# | arg: action - Action to perform with systemctl. Default: reload
ynh_system_reload () {
        local service_name=$1
        local action=${2:-reload}

        # Reload, restart or start and print the log if the service fail to start or reload
        systemctl $action $service_name || ( journalctl --lines=20 -u $service_name >&2 && false)
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
