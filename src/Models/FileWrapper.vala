/* FileWrapper.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public abstract class FileWrapper : Object {
        public File file { get; set; }
        public virtual string name {
            owned get {
                return file.get_basename ();
            }
        }

        public abstract void query_rename (string new_name) throws Error;
        public abstract void query_trash () throws Error;
    }
}
