/* Note.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Note : Object {
        public File file { get; set; }
        public string name {
            owned get {
                return file.get_basename ();
            }
            private set {
                critical ("Notebook name cannot be changed from property");
            }
        }
        public Notebook notebook { get; set; }

        ~Note () {
            message ("A note has been deleted");
        }

        public Note (File f, Notebook n) {
            Object (
                file: f,
                notebook: n
            );
        }

        public void query_rename (string new_name) throws Error {
            File? f = File.new_for_path (Path.build_filename (notebook.file.get_path (), new_name));
            if (f.query_exists ()) {
                throw new Provider.ProviderError.FILE_ALREADY_EXISTS ("Note already exists");
            }

            file = file.set_display_name (new_name);
            notify_property ("name");
        }

        public void query_trash () throws Error {
            notebook.delete_note (this);
        }
    }
}
