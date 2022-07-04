/* NotebookCard.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NotebookCard.ui")]
    public class NotebookCard : Adw.Bin {
        [GtkChild]
        private unowned Gtk.Label title_label;
        [GtkChild]
        private unowned Gtk.Image icon;

        public string title {
            set {
                title_label.label = value;
            }
        }

        public NotebookCard (Notebook notebook) {
            notebook.bind_property ("name", this, "title", SYNC_CREATE);
            notebook.bind_property ("icon-name", icon, "icon-name", SYNC_CREATE);
        }
    }
}
