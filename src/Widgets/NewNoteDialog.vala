/* NewNoteDialog.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NewNoteDialog.ui")]
    public class NewNoteDialog : Adw.Window {
        [GtkChild]
        private unowned Gtk.Entry title_entry;
        [GtkChild]
        private unowned Gtk.Label error_label;

        public unowned Notebook notebook { get; construct; }

        public signal void creation_successful ();

        public class NewNoteDialog (Notebook n, Gtk.Window parent) {
            Object (notebook: n);
            transient_for = parent;
        }

        construct {
            present ();
        }

        [GtkCallback]
        private unowned void on_new_button_clicked () {
            if (title_entry.text == "") {
                return;
            }

            if (title_entry.text.contains (".") || title_entry.text.contains (Path.DIR_SEPARATOR_S)) {
                error_label.visible = true;
                error_label.label = "Title cannot contain “.” or “%s” characters".printf (Path.DIR_SEPARATOR_S);
                return;
            }

            try {
                notebook.create_new_note (title_entry.text);
                creation_successful ();
                close ();
            }
            catch (Error e) {
                error_label.visible = true;
                error_label.label = e.message;
            }
        }
    }
}
