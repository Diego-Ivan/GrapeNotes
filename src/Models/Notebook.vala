/* Notebook.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public errordomain NotebookError {
        NOTE_NOT_FOUND
    }

    public class Notebook : FileWrapper {
        public Backpack backpack { get; set; }

        private Xml.Doc* metadata_doc = null;
        private Xml.Node* color_node;
        private Xml.Node* icon_node;

        private string metadata_path {
            owned get {
                return Path.build_filename (file.get_path (), "metadata.xml");
            }
        }

        private string _icon_name;
        public string icon_name {
            get {
                return _icon_name;
            }
            set {
                return_if_fail (icon_node != null);

                _icon_name = value;
                icon_node->set_content (value);
                metadata_doc->save_file (metadata_path);
            }
        }

        private Gdk.RGBA _color;
        public Gdk.RGBA color {
            get {
                return _color;
            }
            set {
                return_if_fail (color_node != null);

                _color = value;
                color_node->set_content (value.to_string ());
                metadata_doc->save_file (metadata_path);
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
        public signal void loading_completed ();
        public signal void note_deleted ();
        public signal void path_changed ();

        public Notebook (File f) {
            Object (file: f);

            Idle.add (() => {
                try {
                    collect_notes_from_file ();
                    fullfill_metadata ();
                }
                catch (Error e) {
                    critical (e.message);
                }

                return Source.REMOVE;
            });
        }

        public Notebook.with_info (File f, string icon, Gdk.RGBA rgba) {
            Object (file: f);

            // Setup Metadata XML file
            metadata_doc = new Xml.Doc ("1.0");
            Xml.Node* root_element = new Xml.Node (null, "metadata");
            color_node = new Xml.Node (null, "color");
            icon_node = new Xml.Node (null, "icon");

            root_element->add_child (color_node);
            root_element->add_child (icon_node);

            metadata_doc->set_root_element (root_element);
            metadata_doc->save_file (metadata_path);

            // Set icon names and title
            icon_name = icon;
            color = rgba;
        }

        ~Notebook () {
            delete metadata_doc;
        }

        construct {
            notes.items_changed.connect (() => {
                length_changed ();
            });
        }

        public void create_new_note (string title) throws Error {
            File? note_file = File.new_for_path (Path.build_filename (file.get_path (), title));
            if (note_file.query_exists ()) {
                throw new Provider.ProviderError.FILE_ALREADY_EXISTS ("This Note Already Exists");
            }

            note_file.create (NONE);

            Note new_note = new Note (note_file, this);
            notes.append (new_note);
        }

        public override void query_trash () throws Error {
            backpack.trash_notebook (this);
        }

        public override void query_rename (string new_name) throws Error {
            file = file.set_display_name (new_name);
            path_changed ();
            notify_property ("name");
        }

        public void delete_note (Note note) throws Error {
            uint position;
            bool found = notes.find (note, out position);
            if (!found) {
                throw new NotebookError.NOTE_NOT_FOUND ("Note %s was not found in Notebook %s", note.name, name);
            }

            note.file.trash ();
            notes.remove (position);

            note_deleted ();
        }

        private inline void collect_notes_from_file () throws Error {
            FileInfo? info = null;
            FileEnumerator enumerator = file.enumerate_children ("standard::*", NOFOLLOW_SYMLINKS);

            while ((info = enumerator.next_file (null)) != null) {
                File child = enumerator.get_child (info);

                if (info.get_file_type () != REGULAR) {
                    continue;
                }
                string? content_type = info.get_content_type ();
                bool hidden = info.get_is_hidden ();
                if ((content_type == "text/plain" || content_type == "text/markdown") && (!hidden)) {
                    notes.append (new Note (child, this));
                    message (info.get_name ());
                    continue;
                }

                if ((content_type == "application/xml" || content_type == "text/xml") && info.get_name () == "metadata.xml") {
                    metadata_doc = Xml.Parser.parse_file (child.get_path ());
                }
            }

            loading_completed ();
        }

        private inline void fullfill_metadata () {
            if (metadata_doc == null) {
                warning ("Metadata document for Notebook %s was not found, creating one", name);
                metadata_doc = new Xml.Doc ("1.0");

                Xml.Node* root_element = new Xml.Node (null, "metadata");
                metadata_doc->set_root_element (root_element);

                color_node = root_element->new_text_child (null, "color", "#1c71d8");
                icon_node = root_element->new_text_child (null, "icon", "notepad-symbolic");

                metadata_doc->save_file (metadata_path);
                return;
            }

            for (Xml.Node* i = metadata_doc->get_root_element ()->children; i != null; i = i->next) {
                if (i->type == ELEMENT_NODE) {
                    switch (i->name) {
                        case "color":
                            color_node = XmlUtils.get_content_node (i, "color");
                            _color.parse (color_node->get_content ());
                            notify_property ("color");
                            break;
                        case "icon":
                            icon_node = XmlUtils.get_content_node (i, "icon");
                            icon_name = icon_node->get_content ();
                            break;
                    }
                }
            }

            metadata_doc->save_file (metadata_path);
        }
    }
}
