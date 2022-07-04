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

        public unowned Backpack backpack { get; construct; }

        public signal void creation_successful ();

        public NewNotebookDialog (Backpack b, Gtk.Window parent) {
            Object (backpack: b);
            set_transient_for (parent);
        }

        static construct {
            typeof(IconPopover).ensure ();
        }

        construct {
            present ();
            Gdk.RGBA default_color = { 1, 1, 1, 1 };
            default_color.parse ("#1c71d8");

            color_button.rgba = default_color;
        }

        [GtkCallback]
        private void on_new_button_clicked () {
            string result;
            if (!Provider.validate_file_title (title_entry.text, out result)) {
                error_label.visible = true;
                error_label.label = result;
                return;
            }

            try {
                backpack.create_new_notebook (title_entry.text, icon_button.icon_name, color_button.rgba);
                creation_successful ();
                close ();
            }
            catch (Error e) {
                error_label.label = e.message;
            }
        }

        [GtkCallback]
        private void on_cancel_button_clicked () {
            close ();
        }
    }
}
