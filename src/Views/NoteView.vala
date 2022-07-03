/* NoteView.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NoteView.ui")]
    public class NoteView : View {
        [GtkChild]
        private unowned Gtk.ListView list_view;
        private Gtk.SingleSelection selection_model = new Gtk.SingleSelection (null);

        public signal void note_selected (Note? note, bool on_deletion);

        private Notebook? _notebook;
        public Notebook? notebook {
            get {
                return _notebook;
            }
            set {
                _notebook = value;
                selection_model.model = notebook.notes;

                notebook.length_changed.connect (check_for_empty_notebook);
                notebook.loading_completed.connect (() => {
                    select_first_note ();
                });
                notebook.note_deleted.connect (() => {
                    message (selection_model.selected.to_string ());
                    selection_model.select_item (selection_model.selected, true);
                    if (empty) {
                        note_selected (null, true);
                    }
                });

                select_first_note ();
                check_for_empty_notebook ();
            }
        }

        construct {
            var factory = new Gtk.SignalListItemFactory ();
            factory.bind.connect ((item) => {
                Note note = (Note) item.item;
                item.child = new NoteCard (note);
            });
            list_view.factory = factory;
            list_view.model = selection_model;

            selection_model.selection_changed.connect (() => {
                Note note = (Note) selection_model.model.get_item (selection_model.selected);
                note_selected (note, false);
            });
        }

        [GtkCallback]
        private void on_new_note () requires (notebook != null) {
            var dialog = new NewNoteDialog (notebook, (Gtk.Window) get_native ());
            dialog.creation_successful.connect (() => {
                selection_model.select_item (notebook.notes.get_n_items (), true);
                selection_model.select_item (notebook.notes.get_n_items () - 1, true);
            });
        }

        private void check_for_empty_notebook () {
            if (notebook.length == 0) {
                empty = true;
                return;
            }
            empty = false;
        }

        private void select_first_note () {
            selection_model.select_item (notebook.notes.get_n_items (), true);

            if (notebook.notes.get_n_items () == 0) {
                note_selected (null, false);
            }
            selection_model.select_item (0, true);
        }
    }
}
