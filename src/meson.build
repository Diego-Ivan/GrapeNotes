GrapeNotes_sources += [
  'Application.vala',
  'Provider.vala',
  'XmlUtils.vala',

  'ListModels/IconListModel.vala',

  'Widgets/MainWindow.vala',

  # Note Widgets
  'Widgets/NewNoteDialog.vala',
  'Widgets/NoteCard.vala',
  'Widgets/NotePopover.vala',
  'Widgets/NoteRenameDialog.vala',

  # Notebook Widgets
  'Widgets/IconPopover.vala',
  'Widgets/NewNotebookDialog.vala',
  'Widgets/NotebookCard.vala',

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
