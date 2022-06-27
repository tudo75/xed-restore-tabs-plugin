conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('libdir', get_option ('libdir'))
conf.set('PROJECT_NAME', 'com.github.tudo75.xed-restore-tabs-plugin')
conf.set('PROJECT_VERSION', meson.project_version())

pluginsdatadir = join_paths(datadir, 'xed', 'plugins')
pluginslibdir = join_paths(libdir, 'xed', 'plugins')

sources = files(
    'restore-tabs.vala',
)

librestoretabs = library(
    'restore-tabs',
    sources,
    vala_header: 'restore-tabs.h',
    dependencies : dependencies,
    vala_args: [
        '--abi-stability'
    ],
    install: true,
    include_directories: include_dirs,
    install_rpath: join_paths(prefix, libdir, 'xed'),
    install_dir: [
        pluginslibdir,
        true,
        vapidir,
    ]
)
