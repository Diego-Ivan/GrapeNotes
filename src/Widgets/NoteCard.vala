/* NoteCard.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NoteCard.ui")]
    public class NoteCard : Adw.Bin {
        [GtkChild]
        private unowned Gtk.Label title_label;

        public NoteCard (Note note) {
            note.bind_property ("name", title_label, "label", SYNC_CREATE);
        }
    }
}
