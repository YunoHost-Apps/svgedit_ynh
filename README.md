# SVG-edit for YunoHost

[![Integration level](https://dash.yunohost.org/integration/svgedit.svg)](https://dash.yunohost.org/appci/app/svgedit) ![](https://ci-apps.yunohost.org/ci/badges/svgedit.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/svgedit.maintain.svg)  
[![Install SVG-edit with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=svgedit)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install SVG-edit quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview
SVG-edit is a fast, web-based, javascript-driven SVG drawing editor that works in any modern browser.

**Shipped version:** 5.1.0

## Screenshots

![](https://raw.githubusercontent.com/SVG-Edit/svgedit/master/docs/screenshot.png)

## Demo

* [Official demo](https://svg-edit.github.io/svgedit/dist/editor/index.html)

## Configuration

## Documentation

* Official documentation: Link to the official documentation of this app
* YunoHost documentation: If specific documentation is needed, feel free to contribute.

## YunoHost specific features

#### Multi-users support

Not supported.

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/svgedit%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/svgedit/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/svgedit%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/svgedit/)

## Limitations

There is no account management in SVG-edit, but the SSO can protect the access to the app to disallow user without YunoHost account.

## Additionnal informations

## Links

 * Report a bug: https://github.com/YunoHost-Apps/svgedit_ynh/issues
 * Website: https://github.com/SVG-Edit/svgedit
 * YunoHost website: https://yunohost.org/

---

## Developers infos

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
or
sudo yunohost app upgrade leed -u https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
```
