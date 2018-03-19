# SVG Edit app for YunoHost

[![Integration level](https://dash.yunohost.org/integration/svgedit.svg)](https://ci-apps.yunohost.org/jenkins/job/svgedit%20%28Community%29/lastBuild/consoleFull)  
[![Install SVG Edit with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=svgedit)

> *This package allow you to install SVG Edit quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview
SVG-edit is a fast, web-based, javascript-driven SVG drawing editor that works in any modern browser.

**Shipped version:** 2.8.1

**Categories:** Productivity, Drawing

## Screenshots
![alt text](https://svg-edit.github.io/svgedit/images/logo48x48.svg "svg-edit logo of a pencil") SVG-edit 


## Configuration

## Documentation

* YunoHost documentation: There no other documentations, feel free to contribute.

## YunoHost specific features

#### Multi-users support

Not supported.

#### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/jenkins/job/leed%20(Community)/badge/icon)](https://ci-apps.yunohost.org/jenkins/job/svgedit%20(Community)/)
* ARMv8-A - [![Build Status](https://ci-apps.yunohost.org/jenkins/job/leed%20(Community)%20(%7EARM%7E)/badge/icon)](https://ci-apps.yunohost.org/jenkins/job/svgedit%20(Community)%20(%7EARM%7E)/)

## Limitations

* There is no account management in SVG Edit, but the SSO can protect the access to the app to disallow user without yunohost account.

## Additionnal informations

## Links

 * Report a bug: https://github.com/YunoHost-Apps/svgedit_ynh/issues
 * Website: https://github.com/SVG-Edit/svgedit
 * YunoHost website: https://yunohost.org/

---

Developers infos
----------------

**Package by:** Luc Didry

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
or
sudo yunohost app upgrade leed -u https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
```
