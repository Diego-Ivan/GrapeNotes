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

        private unowned Note _note;
        public unowned Note note {
            get {
                return _note;
            }
            set {
                _note = value;
                current_name_label.label = "Rename “%s”".printf (value.name);
            }
        }

        public NoteRenameDialog (Note n, Gtk.Window parent) {
            Object (note: n);
            set_transient_for (parent);
        }

        construct {
            present ();
        }

        [GtkCallback]
        private void on_rename_button_clicked () {
            if (title_entry.text == "") {
                return;
            }

            if (title_entry.text.contains ("\"")) {
                error_label.visible = true;
                error_label.label = "Title cannot contain “\"” characters";
            }

            if (title_entry.text.contains (".") || title_entry.text.contains (Path.DIR_SEPARATOR_S)) {
                error_label.visible = true;
                error_label.label = "Title cannot contain “.” or “%s” characters".printf (Path.DIR_SEPARATOR_S);
                return;
            }

            try {
                note.query_rename (title_entry.text);
                close ();
            }
            catch (Error e) {
                error_label.visible = true;
                error_label.label = e.message;
            }
        }
    }
}
