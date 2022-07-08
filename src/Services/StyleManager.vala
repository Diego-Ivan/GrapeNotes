/* StyleManager.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class StyleManager : Object {
        private Gtk.CssProvider css_provider = new Gtk.CssProvider ();
        private Settings settings;

        private GtkSource.StyleScheme _selected_scheme;
        public GtkSource.StyleScheme selected_scheme {
            get {
                return _selected_scheme;
            }
            set {
                _selected_scheme = value;
                settings.set_string ("theme", value.id);
            }
        }

        private Pango.FontDescription _source_font_description;
        public Pango.FontDescription source_font_description {
            get {
                return _source_font_description;
            }
            set {
                _source_font_description = value;
                css_provider.load_from_data (
                    ".note-source-view { %s }".printf (CssUtils.font_description_to_css (value)).data
                );

                settings.set_string ("font", value.to_string ());
            }
        }

        [CCode (has_construct_function = false)]
        protected StyleManager () {
        }

        private static StyleManager? instance = null;
        public static StyleManager get_default () {
            if (instance == null) {
                instance = new StyleManager ();
            }
            return instance;
        }

        construct {
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (),
                css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            settings = new Settings ("io.github.diegoivan.Grape-Notes");
            source_font_description = Pango.FontDescription.from_string (settings.get_string ("font"));
            selected_scheme = GtkSource.StyleSchemeManager.get_default ().get_scheme (settings.get_string ("theme"));
        }
    }
}
