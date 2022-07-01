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

        public signal void notebook_created (Notebook notebook);

        public NewNotebookDialog (Gtk.Window parent) {
            present ();
            set_transient_for (parent);
        }

        construct {
            color_button.rgba = { 1, 1, 1, 1 };
        }

        [GtkCallback]
        private void on_new_button_clicked () {
            if (title_entry.text == "") {
                return;
            }

            string path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "Notebooks", title_entry.text);
            try {
                File? folder = Provider.create_file_at_path (path);
                if (folder != null) {
                    notebook_created (new Notebook.with_info (folder, "notepad-symbolic", color_button.rgba));
                }
            }
            catch (Error e) {
                error_label.visible = true;
                error_label.label = e.message;
            }
        }
    }
}
