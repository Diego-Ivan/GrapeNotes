project('Grape-Notes', ['c', 'vala'],
           version: '0.0.1',
     meson_version: '>= 0.59.0',
   default_options: [ 'warning_level=2',
       	            ],
)

pkgdata_dir = get_option('prefix') / get_option('datadir') / meson.project_name()

app_title = 'grape-notes'
app_summary = 'Overly simple and personal note-taking app'

app_id = 'io.github.diegoivan.Grape-Notes'
app_name = meson.project_name()

conf_data = configuration_data()
conf_data.set_quoted('APP_ID', app_id)
conf_data.set_quoted('APP_PATH', '/' + app_id.replace('.', '/') + '/')
conf_data.set_quoted('APP_NAME', app_name)
conf_data.set_quoted('G_LOG_DOMAIN', 'GrapeNotes')
conf_data.set_quoted('APP_TITLE', app_title)
conf_data.set_quoted('APP_SUMMARY', app_summary)
configure_file(output: 'config.h', configuration: conf_data)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

GrapeNotes_sources = []

valac = meson.get_compiler('vala')
vapi_dir = meson.project_source_root() / 'vapi'

# Dependencies

libadwaita_dep = dependency('libadwaita-1',
  version: '>= 1.0.0-alpha.2',
  required: false,
)

GrapeNotes_deps = [
    dependency('gio-2.0', version: '>= 2.50'),
    dependency('gtk4', version: '>= 4.2'),
    dependency('gtksourceview-5'),
    dependency('libxml-2.0'),
    libadwaita_dep,
    valac.find_library('config', dirs: vapi_dir),
]

i18n = import('i18n')

subdir('data')
subdir('resources')
subdir('src')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)