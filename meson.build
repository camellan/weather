# Project name-language-version
project('com.github.bitseater.weather', ['vala', 'c'], version: '0.6.1')

# Main libraries
gnome = import('gnome')
i18n = import('i18n')

# Add vapi files
add_project_arguments(
  [
    '--vapidir',
    join_paths(meson.current_source_dir(), 'vapi')
  ],
  language: 'vala'
)

# Add locale support
conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('PREFIX', get_option('prefix'))
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('PACKAGE', meson.project_name())
conf.set_quoted('LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PKG_DATADIR', join_paths(get_option('prefix'), get_option('datadir'), meson.project_name()))

configure_file(
  output: 'config.h',
  configuration: conf
)
config_h_dir = include_directories('src')

# Arguments C - no gcc warnings
c_args = [
  '-include', 'config.h',
  '-w', '-DGETTEXT_PACKAGE="' + meson.project_name() + '"'
]

cc = meson.get_compiler('c')

## Compile GResources
asresources = gnome.compile_resources(
    'as-resources', join_paths('data', meson.project_name() + '.gresource.xml'),
    source_dir: 'data',
    c_name: 'as'
)

# Add subfolders
subdir('data')
subdir('po')

# Define executable
executable(
    meson.project_name(),
    'src/Constants.vala',
    'src/MainWindow.vala',
    'src/Utils/GeoLocate.vala',
    'src/Utils/Iconame.vala',
    'src/Utils/MapCity.vala',
    'src/Utils/MapLayer.vala',
    'src/Utils/MiniMap.vala',
    'src/Utils/OWM_Today.vala',
    'src/Utils/Utils.vala',
    'src/Weather.vala',
    'src/Widgets/About.vala',
    'src/Widgets/Apikey.vala',
    'src/Widgets/City.vala',
    'src/Widgets/Current.vala',
    'src/Widgets/Forecast.vala',
    'src/Widgets/Header.vala',
    'src/Widgets/MapView.vala',
    'src/Widgets/MapViewOWM.vala',
    'src/Widgets/Preferences.vala',
    'src/Widgets/Ticket.vala',
    'src/Widgets/Today.vala',
    'src/Widgets/ViewFile.vala',
    asresources,
    c_args: c_args,
    dependencies: [
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('glib-2.0'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('clutter-1.0'),
        dependency('champlain-0.12'),
        dependency('clutter-gtk-1.0'),
        dependency('geocode-glib-1.0'),
        dependency('webkit2gtk-4.0'),
        dependency('appindicator3-0.1'),
    ],

    vala_args: [
        meson.source_root() + '/vapi/config.vapi'
    ],
    link_args: ['-lm'],
    install : true
)

# Add post install script
meson.add_install_script('meson/post_install.py')
