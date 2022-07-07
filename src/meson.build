GrapeNotes_sources += [
  'Application.vala',
  'Provider.vala',
  'XmlUtils.vala',

  'ListModels/IconListModel.vala',

  'Widgets/MainWindow.vala',
  'Widgets/EditWrapperDialog.vala',

  # Note Widgets
  'Widgets/NewNoteDialog.vala',
  'Widgets/NoteCard.vala',
  'Widgets/NotePopover.vala',

  # Notebook Widgets
  'Widgets/IconPopover.vala',
  'Widgets/NewNotebookDialog.vala',
  'Widgets/NotebookPopover.vala',
  'Widgets/NotebookCard.vala',
  'Widgets/EditNotebookDialog.vala',

  # Views
  'Views/NotebookView.vala',
  'Views/NoteSourceView.vala',
  'Views/NoteView.vala',
  'Views/View.vala',

  # Models
  'Models/Backpack.vala',
  'Models/FileWrapper.vala',
  'Models/Note.vala',
  'Models/Notebook.vala',
]

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('APP_PATH', '/' + app_id.replace('.', '/') + '/')
conf.set_quoted('APP_NAME', app_name)
conf.set_quoted('G_LOG_DOMAIN', 'GrapeNotes')
conf.set_quoted('APP_TITLE', app_title)
conf.set_quoted('APP_SUMMARY', app_summary)
configure_file(output: 'config.h', configuration: conf)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

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
