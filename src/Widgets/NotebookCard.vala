/* NotebookCard.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NotebookCard.ui")]
    public class NotebookCard : Adw.Bin {
        [GtkChild]
        private unowned Gtk.Label title_label;
        [GtkChild]
        private unowned Gtk.Image icon;

        private NotebookPopover popover;

        public unowned Notebook _notebook;
        public unowned Notebook notebook {
            get {
                return _notebook;
            }
            construct {
                _notebook = value;

                notebook.bind_property ("name", title_label, "label", SYNC_CREATE);
                notebook.bind_property ("icon-name", icon, "icon-name", SYNC_CREATE);
            }
        }

        ~NotebookCard () {
            message ("NotebookCard Deleted");
        }

        public NotebookCard (Notebook n) {
            Object (notebook: n);
        }

        construct {
            var click_controller = new Gtk.GestureClick () {
                button = Gdk.BUTTON_SECONDARY
            };
            click_controller.pressed.connect (on_right_click_pressed);
            add_controller (click_controller);

            popover = new NotebookPopover ();
            popover.set_parent (this);
            popover.default_widget = this;
            popover.has_arrow = false;

            popover.asked_trash.connect (on_asked_trash);
            popover.asked_edit.connect (on_asked_edit);
        }

        public override void dispose () {
            base.dispose ();

            popover.default_widget = null;
            popover.unparent ();
        }

        private void on_asked_edit () {
            new EditNotebookDialog (notebook, (Gtk.Window) get_root ());
        }

        private void on_asked_trash () {
            var dialog = new Gtk.MessageDialog ((Gtk.Window) get_root (), MODAL | DESTROY_WITH_PARENT, QUESTION,
            OK_CANCEL, "");

            dialog.text = "Delete %s ?".printf (notebook.name);
            dialog.secondary_text = "This will send the note to your system's trash bin";

            dialog.response.connect ((res) => {
                if (res == Gtk.ResponseType.OK) {
                    try {
                        notebook.query_trash ();
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
