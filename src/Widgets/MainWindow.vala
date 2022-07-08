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

        public StyleManager style { get; set; default = StyleManager.get_default (); }

        private const ActionEntry[] WIN_ACTIONS = {
            { "preferences", on_preferences_action }
        };

        static construct {
            typeof (NotebookView).ensure ();
        }
        public MainWindow (Application app) {
            Object (
                application: app
            );
        }

        construct {
            var action_group = new SimpleActionGroup ();
            action_group.add_action_entries (WIN_ACTIONS, this);

            insert_action_group ("win", action_group);
        }

        private void on_preferences_action () {
            new PreferencesWindow (this);
        }

        [GtkCallback]
        private void on_notebook_changed (Notebook? notebook) {
            note_view.notebook = notebook;
        }

        [GtkCallback]
        private void on_note_selected (Note? note, bool on_deletion) {
            source_view.load_and_save_note.begin (note);
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
