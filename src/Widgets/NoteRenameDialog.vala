/* NoteRenameDialog.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NoteRenameDialog.ui")]
    public class NoteRenameDialog : Adw.Window {
        [GtkChild]
        private unowned Gtk.Label current_name_label;
        [GtkChild]
        private unowned Gtk.Entry title_entry;
        [GtkChild]
        private unowned Gtk.Label error_label;

        private unowned FileWrapper _element;
        public unowned FileWrapper element {
            get {
                return _element;
            }
            set {
                _element = value;
                current_name_label.label = "Rename “%s”".printf (value.name);
            }
        }

        public NoteRenameDialog (FileWrapper n, Gtk.Window parent) {
            Object (element: n);
            set_transient_for (parent);
            modal = true;
        }

        construct {
            present ();
        }

        [GtkCallback]
        private void on_rename_button_clicked () {
            string result;
            if (!Provider.validate_file_title (title_entry.text, out result)) {
                error_label.visible = true;
                error_label.label = result;
                return;
            }

            try {
                element.query_rename (title_entry.text);
                close ();
            }
            catch (Error e) {
                error_label.visible = true;
                error_label.label = e.message;
            }
        }
    }
}
