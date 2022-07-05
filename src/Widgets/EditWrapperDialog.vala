/* EditWrapperDialog.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/EditWrapperDialog.ui")]
    public class EditWrapperDialog : Adw.Window, Gtk.Buildable {
        [GtkChild]
        private unowned Gtk.Label error_label;
        [GtkChild]
        private unowned Gtk.Entry title_entry;
        [GtkChild]
        private unowned Gtk.Box elements_box;

        protected FileWrapper _element;
        public virtual FileWrapper element {
            get {
                return _element;
            }
            set {
                _element = value;
                title_entry.placeholder_text = element.name;
            }
        }

        public EditWrapperDialog (FileWrapper f, Gtk.Window parent) {
            Object (
                element: f,
                transient_for: parent
            );
            modal = true;
        }

        construct {
            present ();
        }

        [GtkCallback]
        protected virtual void on_edit_button_clicked () {
            string result;
            if (!Provider.validate_file_title (title_entry.text, out result)) {
                display_error (result);
                return;
            }

            try {
                element.query_rename (title_entry.text);
                close ();
            }
            catch (Error e) {
                display_error (e.message);
            }
        }

        protected void display_error (string message) {
            error_label.visible = true;
            error_label.label = message;
        }

        public void add_child (Gtk.Builder builder, Object child, string? type) {
            switch (type) {
                case "prefix":
                    add_element_prefix ((Gtk.Widget) child);
                    break;
                case "suffix":
                    add_element_suffix ((Gtk.Widget) child);
                    break;
                default:
                    base.add_child (builder, child, type);
                    break;
            }
        }

        public void add_element_prefix (Gtk.Widget prefix) {
            elements_box.prepend (prefix);
        }

        public void add_element_suffix (Gtk.Widget suffix) {
            elements_box.append (suffix);
        }
    }
}
