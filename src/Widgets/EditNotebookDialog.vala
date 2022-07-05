/* EditNotebookDialog.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/EditNotebookDialog.ui")]
    public class EditNotebookDialog : EditWrapperDialog {
        [GtkChild]
        private unowned Gtk.ColorButton color_button;
        [GtkChild]
        private unowned Gtk.MenuButton icon_button;

        public override FileWrapper element {
            get {
                return base.element;
            }
            set {
                base.element = value;
                var notebook = (Notebook) element;

                color_button.rgba = notebook.color;
                icon_button.icon_name = notebook.icon_name;
            }
        }

        static construct {
            typeof(IconPopover).ensure ();
        }

        public EditNotebookDialog (Notebook notebook, Gtk.Window parent) {
            Object (
                element: notebook,
                transient_for: parent
            );
            modal = true;
        }

        protected override void on_edit_button_clicked () {
            var notebook = (Notebook) element;
            notebook.icon_name = icon_button.icon_name;
            notebook.color = color_button.rgba;

            base.on_edit_button_clicked ();
        }

        [GtkCallback]
        private void on_icon_selected (string icon) {
            icon_button.icon_name = icon;
        }
    }
}
