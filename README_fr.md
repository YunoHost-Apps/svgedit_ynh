# SVG-edit pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/svgedit.svg)](https://dash.yunohost.org/appci/app/svgedit) ![](https://ci-apps.yunohost.org/ci/badges/svgedit.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/svgedit.maintain.svg)  
[![Installer SVG-edit avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=svgedit)

*[Read this readme in english.](./README.md)* 

> *Ce package vous permet d'installer SVG-edit rapidement et simplement sur un serveur YunoHost.  
Si vous n'avez pas YunoHost, consultez [le guide](https://yunohost.org/#/install) pour apprendre comment l'installer.*

## Vue d'ensemble
SVG-edit est un éditeur de dessin SVG rapide, basé sur le Web et piloté par JavaScript, qui fonctionne dans n'importe quel navigateur moderne.

**Version incluse :** 5.1.0

## Captures d'écran

![](https://raw.githubusercontent.com/SVG-Edit/svgedit/master/docs/screenshot.png)

## Démo

* [Démo officielle](https://svg-edit.github.io/svgedit/dist/editor/index.html)

## Configuration

## Documentation

* Documentation officielle : Lien vers la documentation officielle de cette application.
* Documentation YunoHost : Si une documentation spécifique est nécessaire, n'hésitez pas à contribuer.

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateur

Non supporté.

#### Architectures supportées

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/svgedit%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/svgedit/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/svgedit%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/svgedit/)

## Limitations

Il n'y a pas de gestion de compte dans SVG-edit, mais le SSO peut protéger l'accès à l'application pour interdire l'utilisateur sans compte YunoHost.

## Informations additionnelles

## Liens

 * Signaler un bug : https://github.com/YunoHost-Apps/svgedit_ynh/issues
 * Dépôt de l'application principale : https://github.com/SVG-Edit/svgedit
 * Site web YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
or
sudo yunohost app upgrade leed -u https://github.com/YunoHost-Apps/svgedit_ynh/tree/testing --verbose
```
