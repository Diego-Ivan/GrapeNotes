/* NoteSourceView.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/NoteSourceView.ui")]
    public class NoteSourceView : View {
        [GtkChild]
        private unowned GtkSource.View source_view;

        private const ActionEntry[] SOURCE_VIEW_ACTIONS = {
            { "save", save_note }
        };

        private bool changed { get; set; default = false; }

        private GtkSource.Buffer buffer {
            get {
                return (GtkSource.Buffer) source_view.buffer;
            }
        }

        public unowned Note? note { get; set; }

        public async void load_and_save_note (Note? new_note) {
            if (note != null && changed) {
                try {
                    FileUtils.set_contents (note.file.get_path (), source_view.buffer.text);
                }
                catch (Error e) {
                    critical (e.message);
                }

                message ("Nota Guardada");
            }

            note = new_note;

            if (note == null) {
                empty = true;
                return;
            }

            empty = false;
            var source_file = new GtkSource.File () {
                location = note.file
            };
            var loader = new GtkSource.FileLoader (buffer, source_file);

            try {
                yield loader.load_async (Priority.DEFAULT, null, null);
                changed = false; // Setting Changed to null given that the buffer has been changed
            }
            catch (Error e) {
                critical (e.message);
            }
        }

        construct {
            note = null;

            var group = new SimpleActionGroup ();
            group.add_action_entries (SOURCE_VIEW_ACTIONS, this);
            insert_action_group ("source-view", group);

            header_bar.add_css_class ("flat");
            buffer.changed.connect (() => {
                changed = true;
            });
        }

        public void save_note () requires (note != null) {
            try {
                FileUtils.set_contents (note.file.get_path (), buffer.text);
            }
            catch (Error e) {
                critical (e.message);
            }
        }

        public inline void save_note_async () requires (note != null) {
            Thread<void> thread = new Thread<void> ("save_thread", () => {
                try {
                    FileUtils.set_contents (note.file.get_path (), source_view.buffer.text);
                    message ("Nota Guardada");
                }
                catch (Error e) {
                }
            });

            thread.join ();
        }
    }
}
