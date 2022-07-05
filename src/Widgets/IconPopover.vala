/* IconPopover.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/IconPopover.ui")]
    public class IconPopover : Gtk.Popover {
        [GtkChild]
        private unowned Gtk.FlowBox flow_box;

        public signal void icon_selected (string icon);

        private string _selected_icon;
        public string selected_icon {
            get {
                return _selected_icon;
            }
            set {
                _selected_icon = value;
                icon_selected (value);
            }
        }

        public IconPopover () {
        }

        construct {
            autohide = true;

            var model = new IconListModel ();
            flow_box.bind_model (model, flow_box_create_func);

            StringObject o = (StringObject) model.get_item (0);
            selected_icon = o.str;
        }

        private Gtk.Widget flow_box_create_func (Object item) {
            StringObject obj = (StringObject) item;

            var button = new Gtk.Button.from_icon_name (obj.str);
            button.add_css_class ("flat");
            button.clicked.connect (() => {
                selected_icon = button.icon_name;
                popdown ();
            });

            return button;
        }
    }
}
