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
        private Gtk.GestureClick click_controller;

        private unowned Note _note;
        public unowned Note note {
            get {
                return _note;
            }
            set {
                _note = value;
                note.bind_property ("name", title_label, "label", SYNC_CREATE);
            }
        }

        // ~NoteCard () {
        //     message ("Note Card Deleted");
        // }

        protected override void dispose () {
            base.dispose ();

            popover.set_default_widget (null);
            popover.unparent ();

        }

        public NoteCard (Note n) {
            Object (note: n);
        }

        construct {
            click_controller = new Gtk.GestureClick () {
                button = Gdk.BUTTON_SECONDARY
            };
            click_controller.pressed.connect (on_right_click_pressed);
            add_controller (click_controller);

            popover.default_widget = this;
            popover.set_parent (this);

            popover.asked_rename.connect (on_asked_rename);
            popover.asked_trash.connect (on_asked_trash);
        }

        private void on_asked_rename () {
            new EditWrapperDialog (note, (Gtk.Window) get_root ());
        }

        private void on_asked_trash () {
            var dialog = new Gtk.MessageDialog ((Gtk.Window) get_root (), MODAL | DESTROY_WITH_PARENT, QUESTION,
                OK_CANCEL, "");
            dialog.text = "Delete %s ?".printf (note.name);
            dialog.secondary_text = "This will send the note to your system's trash bin";

            dialog.response.connect ((res) => {
                if (res == Gtk.ResponseType.OK) {
                    try {
                        note.query_trash ();
                    }
                    catch (Error e) {
                        critical (e.message);
                    }
                }

                dialog.close ();
            });

            dialog.show ();
        }

        private void on_right_click_pressed (int n_press, double x, double y) {
            int width = get_allocated_width ();
            int w_distance_from_middle_point = (int) x - (width / 2);

            int height = get_allocated_height ();
            int distance_from_base = (int) (y - height);

            popover.popup ();
            popover.set_offset (w_distance_from_middle_point, distance_from_base);
        }
    }
}
