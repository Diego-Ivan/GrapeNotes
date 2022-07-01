/* NewNotebookDialog.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NewNotebookDialog.ui")]
    public class NewNotebookDialog : Adw.Window {
        [GtkChild]
        private unowned Gtk.ColorButton color_button;
        [GtkChild]
        private unowned Gtk.Entry title_entry;
        [GtkChild]
        private unowned Gtk.Label error_label;
        [GtkChild]
        private unowned Gtk.MenuButton icon_button;

        public signal void notebook_created (Notebook notebook);

        public NewNotebookDialog (Gtk.Window parent) {
            present ();
            set_transient_for (parent);
        }

        static construct {
            typeof(IconPopover).ensure ();
        }

        construct {
            Gdk.RGBA default_color = { 1, 1, 1, 1 };
            default_color.parse ("#1c71d8");

            color_button.rgba = default_color;
        }

        [GtkCallback]
        private void on_new_button_clicked () {
            if (title_entry.text == "") {
                return;
            }

            if (title_entry.text.contains (".") || title_entry.text.contains (Path.DIR_SEPARATOR_S)) {
                error_label.visible = true;
                error_label.label = "Title cannot contain “.” or “%s” characters".printf (Path.DIR_SEPARATOR_S);
                return;
            }

            string path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "Notebooks", title_entry.text);
            try {
                File? folder = Provider.create_file_at_path (path);
                if (folder != null) {
                    notebook_created (new Notebook.with_info (folder, icon_button.icon_name, color_button.rgba));
                    close ();
                }
            }
            catch (Error e) {
                error_label.visible = true;
                error_label.label = e.message;
            }
        }

        [GtkCallback]
        private void on_cancel_button_clicked () {
            close ();
        }
    }
}
