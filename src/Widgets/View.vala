/* View.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes {
    public class View : Adw.Bin, Gtk.Buildable {
        public new Gtk.Widget child {
            get {
                return base.child;
            }
        }
        
        public bool empty {
            get {
                return stack.visible_child_name == "empty-state";
            }
            set {
                stack.set_visible_child_full (value? "empty-state" : "view", NONE);
            }
        }
        
        private Gtk.Widget? _view = null;
        public Gtk.Widget? view {
            get {
                return _view;
            }
            set {
                if (_view != null) {
                    stack.remove (_view);
                }
                stack.add_named (value, "view");
                empty = false;
                _view = value;
            }
        }
        
        public string title {
            get {
                return window_title.title;
            }
            set {
                window_title.title = value;
            }
        }
        
        public string empty_title {
            get {
                return status_page.title;
            }
            set {
                status_page.title = value;
            }
        }
        
        public Gtk.Widget empty_child {
            get {
                return status_page.child;
            }
            set {
                status_page.child = value;
            }
        }
        
        public Adw.HeaderBar header_bar { get; private set; default = new Adw.HeaderBar (); }
        public bool visible_header_buttons {
            get {
                return header_bar.show_end_title_buttons;
            }
            set {
                header_bar.show_end_title_buttons = value;
            }
        }
        
        public Adw.WindowTitle window_title = new Adw.WindowTitle ("", "");
    
        private Gtk.Stack stack = new Gtk.Stack ();
        private Adw.StatusPage status_page = new Adw.StatusPage ();
        
        construct {
            header_bar.title_widget = window_title;
        
            var box = new Gtk.Box (VERTICAL, 0);
            box.append (header_bar);
            box.append (stack);
            
            var clamp = new Adw.Clamp () {
                child = status_page
            };
            
            base.child = box;
        
            stack.add_named (clamp, "empty-state");
        }
        
        public void add_child (Gtk.Builder builder, Object child, string? type) requires (child is Gtk.Widget) {
            switch (type) {
                case "header-prefix":
                    header_bar.pack_start ((Gtk.Widget) child);
                    break;
                case "header-suffix":
                    header_bar.pack_end ((Gtk.Widget) child);
                    break;
                case null:
                    view = (Gtk.Widget) child;
                    break;
                default:
                    critical ("Child with type: %s not supported for GrapeNotesView", type);
                    break;
            }
        }
    }
}
