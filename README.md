# xed-restore-tabs-plugin
Porting of the Gedit Restore Tabs plugin to Xed

## Requirements
To compile some libraries are needed:

* meson
* ninja-build
* valac
* libpeas-1.0-dev
* libpeas-gtk-1.0
* libglib2.0-dev
* libgtk-3-dev
* libxapp-dev
* xed-dev

To install on Ubuntu based distros:

    sudo apt install meson ninja-build build-essential valac cmake libgtk-3-dev libpeas-dev xed-dev libxapp-dev

## Install
Enter the cloned folder and:

    meson setup build --prefix=/usr
    ninja -v -C build com.github.tudo75.xed-restore-tabs-plugin-gmo
    ninja -v -C build
    ninja -v -C build install

## Uninstall
To uninstall and remove all added files, go inside the cloned folder and:

	sudo ninja -v -C build uninstall
    sudo rm /usr/share/locale/en/LC_MESSAGES/com.github.tudo75.xed-restore-tabs-plugin.mo
    sudo rm /usr/share/locale/it/LC_MESSAGES/com.github.tudo75.xed-restore-tabs-plugin.mo

## Instructions
Plugin must be enabled from Settings -> Plugin

Pay attention if you have more than one working window open. Plugin restore the list of opened files only for last closed window.

## Credits

Based on this Gedit Plugin

https://github.com/Quixotix/gedit-restore-tabs
