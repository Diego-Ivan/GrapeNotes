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

        public signal void note_selected (Note? note);

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
                select_first_note ();
                check_for_empty_notebook ();
            }
        }

        construct {
            var factory = new Gtk.SignalListItemFactory ();
            factory.bind.connect ((item) => {
                Note note = (Note) item.item;
                item.child = new Gtk.Label (note.name);
            });
            list_view.factory = factory;
            list_view.model = selection_model;

            selection_model.selection_changed.connect (() => {
                Note note = (Note) selection_model.model.get_item (selection_model.selected);
                note_selected (note);
            });

            selection_model.items_changed.connect (() => {
                selection_model.selected = selection_model.model.get_n_items ();
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
            note_selected ((Note?) selection_model.get_item (0));
        }
    }
}
