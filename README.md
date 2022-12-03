<!--
N.B.: This README was automatically generated by https://github.com/YunoHost/apps/tree/master/tools/README-generator
It shall NOT be edited by hand.
-->

# SVG-edit for YunoHost

[![Integration level](https://dash.yunohost.org/integration/svgedit.svg)](https://dash.yunohost.org/appci/app/svgedit) ![Working status](https://ci-apps.yunohost.org/ci/badges/svgedit.status.svg) ![Maintenance status](https://ci-apps.yunohost.org/ci/badges/svgedit.maintain.svg)  
[![Install SVG-edit with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=svgedit)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install SVG-edit quickly and simply on a YunoHost server.
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview

SVG-edit is a fast, web-based, javascript-driven SVG drawing editor that works in any modern browser.


**Shipped version:** 2.8.1~ynh4

## Screenshots

![Screenshot of SVG-edit](./doc/screenshots/screenshot.png)

## Disclaimers / important information

## Limitations

There is no account management in SVG-edit, but the SSO can protect the access to the app to disallow user without YunoHost account.

## Documentation and resources

* Upstream app code repository: <https://github.com/SVG-Edit/svgedit>
* YunoHost documentation for this app: <https://yunohost.org/app_svgedit>
* Report a bug: <https://github.com/YunoHost-Apps/svgedit_ynh/issues>

## Developer info

Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing).

To try the testing branch, please proceed like that.

``` bash
sudo yunohost app install https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --debug
or
sudo yunohost app upgrade svgedit -u https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --debug
```

**More info regarding app packaging:** <https://yunohost.org/packaging_apps>
