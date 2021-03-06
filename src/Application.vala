/* Application.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Application : Adw.Application {

        private struct AccelEntry {
            string action_name;
            string[] accels;
        }

        private static ActionEntry[] ACTION_ENTRIES = {
            { "quit", on_quit_action },
            { "about", on_about_action }
        };

        private static AccelEntry[] ACCEL_ENTRIES = {
            { "app.quit", {"<Ctrl>q"} },
            { "window.close", {"<Ctrl>w"} }
        };

        public Application () {
            Object (
                flags: ApplicationFlags.FLAGS_NONE,
                application_id: Config.APP_ID
            );
        }

        protected override void startup () {
            base.startup ();
            GtkSource.init ();

            add_action_entries (ACTION_ENTRIES, this);

            foreach (var accel in ACCEL_ENTRIES)
                set_accels_for_action (accel.action_name, accel.accels);
        }

        protected override void activate () {
            var win = get_active_window ();
            if (win == null) {
                win = new GrapeNotes.MainWindow (this);
            }
            win.present ();
        }

        protected void on_quit_action () {
            active_window.close_request ();
            quit ();
        }

        private void on_about_action () {
            const string? COPYRIGHT = "Copyright \xc2\xa9 Diego Iván";

            const string? AUTHORS[] = {
                "Diego Iván<diegoivan.mae@gmail.com>",
                null
            };

            Gtk.show_about_dialog (active_window,
                "program_name", "Grape-Notes",
                "logo-icon-name", Config.APP_ID,
                "copyright", COPYRIGHT,
                "version", Config.VERSION,
                "authors", AUTHORS,
                /// TRANSLATORS: Write your Name<email> here
                "translator-credits", _("translator-credits"),
                null
            );
        }

        public static int main (string[] args) {
            Intl.bindtextdomain (
                Config.GETTEXT_PACKAGE,
                Config.GNOMELOCALEDIR
            );
            Intl.bind_textdomain_codeset (
                Config.GETTEXT_PACKAGE,
                Config.GNOMELOCALEDIR
            );
            Intl.textdomain (Config.GETTEXT_PACKAGE);

            return new GrapeNotes.Application ().run (args);
        }
    }
}
