/* Notebook.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Notebook : Object {
        public File _file;
        public File file {
            get {
                return _file;
            }
            construct {
                _file = value;

                Idle.add (() => {
                    try {
                        collect_notes_from_file ();
                    }
                    catch (Error e) {
                        critical (e.message);
                    }

                    return Source.REMOVE;
                });
            }
        }

        public string name {
            owned get {
                return file.get_basename ();
            }
        }

        public uint n_items {
            get {
                return notes.get_n_items ();
            }
        }

        public ListStore notes { owned get; private set; default = new ListStore (typeof (Note)); }
        public uint length {
            get {
                return notes.get_n_items ();
            }
        }

        public signal void length_changed ();

        public Notebook (File f) {
            Object (file: f);
        }

        construct {
            notes.items_changed.connect (() => {
                length_changed ();
            });
        }

        private void collect_notes_from_file () throws Error {
            FileInfo? info = null;
            FileEnumerator enumerator = file.enumerate_children ("standard::*", NOFOLLOW_SYMLINKS);

            while ((info = enumerator.next_file (null)) != null) {
                File child = enumerator.get_child (info);

                if (info.get_file_type () != REGULAR) {
                    continue;
                }
                string? content_type = info.get_content_type ();
                if (content_type == "text/plain") {
                    notes.append (new Note (child, this));
                    message ("Found a note");
                }
            }
        }
    }
}
