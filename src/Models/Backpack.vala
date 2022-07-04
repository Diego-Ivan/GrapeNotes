/* Backpack.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Backpack : Object {
        public ListStore notebooks { get; set; default = new ListStore (typeof (Notebook)); }
        public uint n_items {
            get {
                return notebooks.get_n_items ();
            }
        }

        public signal void loading_completed ();
        public signal void notebook_removed ();
        public signal void notebook_created ();

        construct {
            Idle.add (() => {
                try {
                    string notebook_path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "Notebooks");
                    Notebook[] notebook_array = Provider.collect_notebooks_from_path (notebook_path);

                    foreach (Notebook notebook in notebook_array) {
                        notebook.backpack = this;
                        notebooks.append (notebook);
                    }

                    loading_completed ();
                }
                catch (Error e) {
                    critical (e.message);
                }

                return Source.REMOVE;
            });
        }

        public void create_new_notebook (string title, string icon, Gdk.RGBA color) throws Error {
            string path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), "Notebooks", title);

            File? folder = Provider.create_file_at_path (path);
            if (folder != null) {
                notebooks.append (new Notebook.with_info (folder, icon, color));
                notebook_created ();
            }
        }

        public void trash_notebook (Notebook notebook) throws Error {
            uint position;
            bool found = notebooks.find (notebook, out position);
            if (!found) {
                throw new Provider.ContainerError.ELEMENT_NOT_EXISTS ("The notebook %s was not found", notebook.name);
            }

            notebook.file.trash ();
            notebooks.remove (position);
            notebook_removed ();
        }
    }
}
