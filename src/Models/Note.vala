/* Note.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class Note : Object {
        public File file { get; construct; }
        public string name {
            owned get {
                return file.get_basename ();
            }
        }
        public Notebook notebook { get; set; }

        public Note (File f, Notebook n) {
            Object (
                file: f,
                notebook: n
            );
        }
    }
}
