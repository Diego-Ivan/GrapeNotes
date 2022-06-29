GrapeNotes_sources += [
  'Application.vala',

  'Widgets/MainWindow.vala',
  'Widgets/View.vala',
]

executable(app_title, GrapeNotes_sources,
  vala_args: [
    '--target-glib=2.50',
    '--vapidir', vapi_dir,
    '--enable-experimental'
  ],
  c_args: [
    '-DVERSION="' + meson.project_version() + '"',
    '-DGETTEXT_PACKAGE="' + app_name + '"',
    '-DGNOMELOCALEDIR="' + get_option('prefix') / get_option('localedir') + '"',
    '-DAPP_ID="' + app_id + '"',
  ],
  dependencies: GrapeNotes_deps,
  install: true
)
