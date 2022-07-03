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
        public signal void note_selected (Note? note, bool on_deletion);

        private Gtk.SingleSelection? selection_model = null;

        private unowned Notebook? _notebook;
        public unowned Notebook? notebook {
            get {
                return _notebook;
            }
            set {
                _notebook = value;
                selection_model = new Gtk.SingleSelection (notebook.notes);
                list_view.model = null;
                list_view.model = selection_model;

                selection_model.selection_changed.connect (() => {
                    Note note = (Note) selection_model.model.get_item (selection_model.selected);
                    note_selected (note, false);
                });

                notebook.length_changed.connect (check_for_empty_notebook);
                notebook.loading_completed.connect (() => {
                    select_first_note ();
                });

                notebook.note_deleted.connect (() => {
                    check_for_empty_notebook ();
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
                Note note =  ((Note) item.item);
                item.child = new NoteCard (note);
            });

            factory.unbind.connect ((item) => {
                item.child.unparent ();
                item.child.dispose ();
            });
            list_view.factory = factory;
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
