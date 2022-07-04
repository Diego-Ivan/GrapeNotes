/* Provider.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


namespace GrapeNotes.Provider {
    public errordomain ProviderError {
        NOT_FOLDER,
        FILE_ALREADY_EXISTS
    }

    public errordomain ContainerError {
        ELEMENT_NOT_EXISTS
    }

    public inline Notebook[] collect_notebooks_from_path (string path) throws Error {
        Notebook[] notebooks = { };
        File folder = File.new_for_path (path);

        if (folder.query_file_type (NOFOLLOW_SYMLINKS) != DIRECTORY) {
            throw new ProviderError.NOT_FOLDER ("Path given is not a directory");
        }

        FileInfo? info = null;
        FileEnumerator enumerator = folder.enumerate_children ("standard::*", NOFOLLOW_SYMLINKS);
        while ((info = enumerator.next_file (null)) != null) {
            File child = enumerator.get_child (info);

            if (info.get_file_type () != DIRECTORY) {
                continue;
            }

            notebooks += new Notebook (child);
        }

        return notebooks;
    }

    public bool validate_file_title (string filename, out string result) {
        if (filename == "") {
            result = "Title is empty";
            return false;
        }

        if (filename.contains (".") || filename.contains (Path.DIR_SEPARATOR_S)) {
            result = "Title cannot contain “.” or “%s” characters".printf (Path.DIR_SEPARATOR_S);
            return false;
        }

        if (filename.has_suffix (" ")) {
            result = "Title cannot have an space at the end";
            return false;
        }

        if (filename.has_prefix (" ")) {
            result = "Title cannot start with an empty space";
            return false;
        }

        result = "";

        return true;
    }

    public inline File create_file_at_path (string path) throws Error {
        File folder = File.new_for_path (path);

        if (folder.query_exists ()) {
            throw new ProviderError.FILE_ALREADY_EXISTS ("Notebook Already Exists");
        }

        folder.make_directory_with_parents ();
        return folder;
    }
}
