#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# App package root directory should be the parent folder
PKG_DIR=$(cd ../; pwd)

pkg_dependencies="wget"

#=================================================
# COMMON HELPERS
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

ynh_read_manifest () {
    if [ -f '../manifest.json' ] ; then
        ynh_read_json '../manifest.json' "$1"
    else
        ynh_read_json '../settings/manifest.json' "$1"
    fi
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

ynh_add_nginx_config () {
    finalnginxconf="/etc/nginx/conf.d/$domain.d/$app.conf"
    ynh_configure nginx.conf "$finalnginxconf"
    service nginx reload
}

# Send an email to inform the administrator
#
# usage: ynh_send_readme_to_admin app_message [recipients]
# | arg: app_message - The message to send to the administrator.
# | arg: recipients - The recipients of this email. Use spaces to separate multiples recipients. - default: root
#	example: "root admin@domain"
#	If you give the name of a YunoHost user, ynh_send_readme_to_admin will find its email adress for you
#	example: "root admin@domain user1 user2"
ynh_send_readme_to_admin() {
	local app_message="${1:-...No specific information...}"
	local recipients="${2:-root}"

	# Retrieve the email of users
	find_mails () {
		local list_mails="$1"
		local mail
		local recipients=" "
		# Read each mail in argument
		for mail in $list_mails
		do
			# Keep root or a real email address as it is
			if [ "$mail" = "root" ] || echo "$mail" | grep --quiet "@"
			then
				recipients="$recipients $mail"
			else
				# But replace an user name without a domain after by its email
				if mail=$(ynh_user_get_info "$mail" "mail" 2> /dev/null)
				then
					recipients="$recipients $mail"
				fi
			fi
		done
		echo "$recipients"
	}
	recipients=$(find_mails "$recipients")

	local mail_subject="☁️🆈🅽🅷☁️: \`$app\` was just installed!"

	local mail_message="This is an automated message from your beloved YunoHost server.
Specific information for the application $app.
$app_message
---
Automatic diagnosis data from YunoHost
$(yunohost tools diagnosis | grep -B 100 "services:" | sed '/services:/d')"

	# Send the email to the recipients
	echo "$mail_message" | mail -a "Content-Type: text/plain; charset=UTF-8" -s "$mail_subject" "$recipients"
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

# Remove any logs for all the following commands.
#
# usage: ynh_print_OFF
# WARNING: You should be careful with this helper, and never forgot to use ynh_print_ON as soon as possible to restore the logging.
ynh_print_OFF () {
	set +x
}

# Restore the logging after ynh_print_OFF
#
# usage: ynh_print_ON
ynh_print_ON () {
	set -x
	# Print an echo only for the log, to be able to know that ynh_print_ON has been called.
	echo ynh_print_ON > /dev/null
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
