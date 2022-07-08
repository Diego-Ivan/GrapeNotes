/* PreferencesWindow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/PreferencesWindow.ui")]
    public class PreferencesWindow : Adw.PreferencesWindow {
        [GtkChild]
        private unowned Gtk.FontButton font_button;

        [GtkChild]
        private unowned GtkSource.StyleSchemeChooserWidget style_scheme;

        public PreferencesWindow (Gtk.Window parent) {
            Object (
                transient_for: parent,
                modal: true
            );
        }

        construct {
            present ();

            var manager = StyleManager.get_default ();
            manager.bind_property ("selected-scheme", style_scheme, "style-scheme", SYNC_CREATE | BIDIRECTIONAL);
            manager.bind_property ("source_font_description", font_button, "font-desc", SYNC_CREATE | BIDIRECTIONAL);
        }
    }
}
