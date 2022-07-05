/* NotePopover.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NotebookPopover.ui")]
    public class NotebookPopover : Gtk.Popover {
        public signal void asked_edit ();
        public signal void asked_trash ();

        public NotebookPopover () {
        }

        [GtkCallback]
        private void on_edit_button_clicked () {
            asked_edit ();
            popdown ();
        }

        [GtkCallback]
        private void on_trash_button_clicked () {
            asked_trash ();
            popdown ();
        }
    }
}
