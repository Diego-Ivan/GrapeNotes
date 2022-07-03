/* NotePopover.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NotePopover.ui")]
    public class NotePopover : Gtk.Popover {
        public signal void asked_rename ();
        public signal void asked_trash ();

        public NotePopover () {
        }

        [GtkCallback]
        private void on_rename_button_clicked () {
            asked_rename ();
            popdown ();
        }

        [GtkCallback]
        private void on_trash_button_clicked () {
            asked_trash ();
            popdown ();
        }
    }
}
