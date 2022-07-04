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

        private Gtk.SingleSelection selection_model;

        private Gtk.CssProvider css_provider = new Gtk.CssProvider ();

        public Gdk.RGBA selected_notebook_color {
            set {
                select_notebook_color (value);
            }
        }

        private unowned Notebook? _selected_notebook;
        public unowned Notebook? selected_notebook {
            get {
                return _selected_notebook;
            }
            set {
                _selected_notebook = value;
                if (value == null)
                    return;

                notebook_selected (value);
                value.bind_property ("color", this, "selected-notebook-color", SYNC_CREATE);
            }
        }

        public Backpack backpack { get; set; }

        construct {
            backpack = new Backpack ();
            backpack.loading_completed.connect (() => {
                if (backpack.n_items == 0) {
                    empty = true;
                }
                selected_notebook = (Notebook) backpack.notebooks.get_item (0);
            });

            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            selection_model = new Gtk.SingleSelection (backpack.notebooks);

            var factory = new Gtk.SignalListItemFactory ();
            factory.bind.connect ((item) => {
                var notebook = (Notebook) item.item;
                item.child = new NotebookCard (notebook);
            });

            list_view.factory = factory;
            list_view.model = selection_model;

            selection_model.selection_changed.connect (() => {
                selected_notebook = (Notebook) backpack.notebooks.get_item (selection_model.selected);
            });
        }

        private void select_notebook_color (Gdk.RGBA color) {
            css_provider.load_from_data ((uint8[])
                "@define-color accent_bg_color %s;".printf (color.to_string ())
            );
        }

        [GtkCallback]
        private void on_new_notebook_button_clicked () {
            var dialog = new NewNotebookDialog (backpack, (Gtk.Window) get_native ());
            dialog.creation_successful.connect (() => {
                selection_model.select_item (backpack.n_items - 1, true);
            });
        }
    }
}
