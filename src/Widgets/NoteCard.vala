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

        private NotePopover popover = new NotePopover ();

        private Note _note;
        public Note note {
            get {
                return _note;
            }
            set {
                _note = value;
                note.bind_property ("name", title_label, "label", SYNC_CREATE);
            }
        }

        public NoteCard (Note n) {
            Object (note: n);
        }

        construct {
            var click_controller = new Gtk.GestureClick () {
                button = Gdk.BUTTON_SECONDARY
            };
            click_controller.pressed.connect (on_right_click_pressed);
            add_controller (click_controller);

            popover.default_widget = this;
            popover.set_parent (this);

            popover.asked_rename.connect (on_asked_rename);
        }

        private void on_asked_rename () {
            new NoteRenameDialog (note, (Gtk.Window) get_root ());
        }

        private void on_right_click_pressed (int n_press, double x, double y) {
            message ("Pressed %i times at x=%f and y=%f", n_press, x, y);

            int width = get_allocated_width ();
            int w_distance_from_middle_point = (int) x - (width / 2);

            int height = get_allocated_height ();
            int distance_from_base = (int) (y - height);
            message (distance_from_base.to_string ());

            popover.popup ();
            popover.set_offset (w_distance_from_middle_point, distance_from_base);
        }
    }
}
