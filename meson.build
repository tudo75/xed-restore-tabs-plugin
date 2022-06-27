# project name and programming language
project('com.github.tudo75.xed-restore-tabs-plugin', ['vala', 'c'], version: '0.0.3')

assert('com.github.tudo75.xed-restore-tabs-plugin.gschema.xml'==meson.project_name() + '.gschema.xml', 'proj name and gschema file not the same')

i18n = import('i18n')
gnome = import('gnome')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

prefix = get_option('prefix')
bindir = get_option('bindir')
datadir = get_option('datadir')
libdir = get_option('libdir')
includedir = get_option('includedir')
libexecdir = get_option('libexecdir')
desktopdir = join_paths(datadir, 'applications')
schema_dir = join_paths(datadir, 'glib-2.0', 'schemas')
include_dirs = include_directories('.', './missing-xed-headers')
vapidir = get_option('datadir') / 'vala' / 'vapi'

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')
add_project_arguments(['--enable-experimental'], language: 'vala')


dependencies = [
	dependency('gtk+-3.0', version: '>= 3.20'),
	dependency('glib-2.0'),
	dependency('gio-2.0'),
	dependency('gio-unix-2.0'),
    dependency('gobject-2.0'),
	dependency('libpeas-1.0'),
	dependency('libpeas-gtk-1.0'),
	dependency('xed'),
]

pkgconfig = import('pkgconfig')

PKGCONFIG_DEPS = [
    'gtk+-3.0',
    'glib-2.0',
    'gio-2.0',
    'gio-unix-2.0',
    'gobject-2.0',
    'libpeas-1.0',
    'libpeas-gtk-1.0',
    'xed',
]

subdir('po')
subdir('src')
subdir('data')

meson.add_install_script('build-aux/post_install.py')
