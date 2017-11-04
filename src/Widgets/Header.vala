/*
* Copyright (c) 2017 bitseater ()
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA 02111-1307, USA.
*
* Authored by: bitseater <bitseater@gmail.com>
*/
namespace Weather.Widgets {

    public class Header : Gtk.HeaderBar {

        public Header (Gtk.Window window, bool view) {
            show_close_button = true;
            var app = window.get_application () as Granite.Application;
            var on_pref = new GLib.SimpleAction ("on_pref", null);
            on_pref.activate.connect (() => {
                var preferences = new Weather.Widgets.Preferences (window);
                preferences.run ();
            });
            app.add_action (on_pref);

            var on_about = new GLib.SimpleAction ("on_about", null);
            on_about.activate.connect (() => {
                app.show_about (window);
            });
            app.add_action (on_about);

            var app_button = new Gtk.Button.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
            var menu = new GLib.Menu ();
            var section1 = new GLib.Menu ();
            var pref_item = new GLib.MenuItem ("Preferences", "app.on_pref");
            section1.append_item (pref_item);
            menu.append_section (null, section1);
            var section2 = new GLib.Menu ();
            var about_item = new GLib.MenuItem ("About Weather", "app.on_about");
            section2.append_item (about_item);
            menu.append_section (null, section2);
            var popover = new Gtk.Popover.from_model (app_button, menu);
            app_button.clicked.connect (() => {
                popover.show_all ();
            });

            var upd_button = new Gtk.Button.from_icon_name ("view-refresh-symbolic", Gtk.IconSize.BUTTON);
            var loc_button = new Gtk.Button.from_icon_name ("mark-location-symbolic", Gtk.IconSize.BUTTON);
            if (view) {
                loc_button.sensitive = true;
                upd_button.sensitive = true;
            } else {
                loc_button.sensitive = false;
                upd_button.sensitive = false;
            }

            loc_button.clicked.connect (() =>{
                window.remove (window.get_child ());
                window.add (new Weather.Widgets.City (window));
                window.show_all ();
            });

            upd_button.clicked.connect (() =>{
                window.remove (window.get_child ());
                window.add (new Weather.Widgets.Current (window));
                window.show_all ();
            });

            pack_end (app_button);
            pack_end (upd_button);
            pack_end (loc_button);
        }

        public void set_title_header (string city, string country) {
            this.title = city + " (" + country + ") ";
        }
    }

}
