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
* libgtksourceview-4-dev
* libxapp-dev
* xed-dev

To install on Ubuntu based distros:

    sudo apt install meson ninja-build build-essential valac cmake libgtk-3-dev libpeas-dev xed-dev libxapp-dev libgtksourceview-4-dev

## Install
On Mint/LMDE you can use the provided deb package (maybe works also for Ubuntu 20.04  but not tested)

Clone the repository and from inside the cloned folder:

    git clone https://github.com/tudo75/xed-restore-tabs-plugin.git
	cd xed-restore-tabs-plugin
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
Plugin must be enabled from Edit -> Preferences -> Plugins -> Restore Tabs

Pay attention if you have more than one working window open. Plugin restore the list of opened files only for last closed window.

## Credits

Based on this Gedit Plugin

https://github.com/Quixotix/gedit-restore-tabs

## My Xed Plugins
* xed-terminal-plugin https://github.com/tudo75/xed-terminal-plugin
* xed-codecomment-plugin https://github.com/tudo75/xed-codecomment-plugin
* xed-sessionsaver-plugin https://github.com/tudo75/xed-sessionsaver-plugin
* xed-restore-tabs-plugin https://github.com/tudo75/xed-restore-tabs-plugin
* xed-plantuml-plugin https://github.com/tudo75/xed-plantuml-plugin 
