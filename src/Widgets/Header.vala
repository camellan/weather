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

        public Gtk.Button upd_button;
        public Gtk.Button loc_button;

        public Header (Gtk.Window window, bool view) {
            show_close_button = true;

            //Create menu
            var menu = new Gtk.Menu ();
            var pref_item = new Gtk.MenuItem.with_label (_("Preferences"));
            var about_item = new Gtk.MenuItem.with_label (_("About Weather"));
            menu.add (pref_item);
            menu.add (new Gtk.SeparatorMenuItem ());
            menu.add (about_item);
            pref_item.activate.connect (() => {
                var preferences = new Weather.Widgets.Preferences (window, this);
                preferences.run ();
            });
            about_item.activate.connect (() => {
                var about = new Weather.Widgets.About (window);
                about.show ();
            });

            var app_button = new Gtk.MenuButton ();
            app_button.popup = menu;
            app_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
            menu.show_all ();

            upd_button = new Gtk.Button.from_icon_name ("view-refresh-symbolic", Gtk.IconSize.BUTTON);
            loc_button = new Gtk.Button.from_icon_name ("mark-location-symbolic", Gtk.IconSize.BUTTON);
            change_visible (false);

            loc_button.clicked.connect (() =>{
                window.remove (window.get_child ());
                window.add (new Weather.Widgets.City (window, this));
                window.show_all ();
            });

            upd_button.clicked.connect (() =>{
                window.remove (window.get_child ());
                window.add (new Weather.Widgets.Current (window, this));
                window.show_all ();
            });

            pack_end (app_button);
            pack_end (upd_button);
            pack_end (loc_button);
        }

        public void change_visible (bool s) {
            this.upd_button.sensitive = s;
            this.loc_button.sensitive = s;
        }
    }
}
