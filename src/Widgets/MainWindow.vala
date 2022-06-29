/* MainWindow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/MainWindow.ui")]
    public class MainWindow : Adw.ApplicationWindow {
        [GtkChild]
        private unowned NoteView note_view;
        [GtkChild]
        private unowned NoteSourceView source_view;

        static construct {
            typeof (NotebookView).ensure ();
        }
        public MainWindow (Application app) {
            Object (
                application: app
            );
        }

        [GtkCallback]
        private void on_notebook_changed (Notebook notebook) {
            note_view.notebook = notebook;
        }

        [GtkCallback]
        private void on_note_selected (Note? note) {
            source_view.note = note;
        }

        [GtkCallback]
        private bool on_close_request () {
            if (source_view.note != null) {
                source_view.save_note ();
            }
            return false;
        }
    }
}
