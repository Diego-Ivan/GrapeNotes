/* Note.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Note : FileWrapper {
        public Notebook _notebook;
        public Notebook notebook {
            get {
                return _notebook;
            }
            set {
                _notebook = value;
                notebook.path_changed.connect (on_notebook_path_changed);
            }
        }

        public Note (File f, Notebook n) {
            Object (
                file: f,
                notebook: n
            );
        }

        public override void query_rename (string new_name) throws Error {
            File? f = File.new_for_path (Path.build_filename (notebook.file.get_path (), new_name));
            if (f.query_exists ()) {
                throw new Provider.ProviderError.FILE_ALREADY_EXISTS ("Note already exists");
            }

            file = file.set_display_name (new_name);
            notify_property ("name");
        }

        public override void query_trash () throws Error {
            notebook.delete_note (this);
        }

        private void on_notebook_path_changed () {
            File? f = File.new_for_path (Path.build_filename (notebook.file.get_path (), file.get_basename ()));
            if (f.query_exists ()) {
                warning ("This path already exists, this action will override contents on file %s", f.get_path ());
            }
            file = f;
        }
    }
}
