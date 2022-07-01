/* IconListModel.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class IconListModel : Object, ListModel {
        private StringObject[] objects = {};

        private const string[] AVAILABLE_ITEMS = {
            "notepad-symbolic", "applications-engineering-symbolic", "avatar-default-symbolic",
            "emoji-activities-symbolic", "applications-utilities-symbolic", "emoji-travel-symbolic",
            "emoji-nature-symbolic", "folder-music-symbolic", "emote-love-symbolic",
            "applications-science-symbolic", "emblem-documents-symbolic", "penguin-alt-symbolic"
        };

        construct {
            foreach (var item in AVAILABLE_ITEMS) {
                objects += new StringObject () {
                    str = item
                };
            }
        }

        public Object? get_item (uint position) {
            return objects[position];
        }

        public uint get_n_items () {
            return objects.length;
        }

        public Type get_item_type () {
            return typeof(StringObject);
        }
    }

    public class StringObject : Object {
        public string str { get; set; default = ""; }
    }
}
