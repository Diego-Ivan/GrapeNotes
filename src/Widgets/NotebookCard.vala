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

        public string title {
            set {
                title_label.label = value;
            }
        }

        private Gtk.CssProvider css_provider = new Gtk.CssProvider ();

        private Gdk.RGBA _color;
        public Gdk.RGBA color {
            get {
                return _color;
            }
            set {
                _color = value;
                css_provider.load_from_data ((uint8[])
                    "* { border-left-color: %s; }".printf (value.to_string ())
                );
            }
        }

        public NotebookCard (Notebook notebook) {
            notebook.bind_property ("name", this, "title", SYNC_CREATE);
            notebook.bind_property ("color", this, "color", SYNC_CREATE);
            notebook.bind_property ("icon-name", icon, "icon-name", SYNC_CREATE);
        }

        construct {
            get_style_context ().add_provider (css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }
    }
}
