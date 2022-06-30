/* NotebookView.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NotebookView.ui")]
    public class NotebookView : View {
        [GtkChild]
        private unowned Gtk.ListView list_view;

        public signal void notebook_selected (Notebook notebook);

        private ListStore notebooks = new ListStore (typeof (Notebook));
        private Gtk.SingleSelection selection_model;

        construct {
            selection_model = new Gtk.SingleSelection (notebooks);

            var factory = new Gtk.SignalListItemFactory ();
            factory.bind.connect ((item) => {
                var notebook = (Notebook) item.item;
                item.child = new NotebookCard (notebook);
            });

            list_view.factory = factory;
            list_view.model = selection_model;

            selection_model.selection_changed.connect (() => {
                Notebook notebook = (Notebook) notebooks.get_item (selection_model.selected);
                notebook_selected (notebook);
            });

            Idle.add (() => {
                try {
                    string path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "Notebooks");
                    Notebook[] n = Provider.collect_notebooks_from_path (path);

                    for (int i = 0; i < n.length; i++) {
                        notebooks.append (n[i]);
                    }

                    if (notebooks.get_n_items () == 0) {
                        empty = true;
                        return Source.REMOVE;
                    }

                    notebook_selected ((Notebook) notebooks.get_item (selection_model.selected));
                }
                catch (Error e) {
                    critical (e.message);
                }

                return Source.REMOVE;
            });
        }
    }
}
