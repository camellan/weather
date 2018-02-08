/*
* Copyright (c) 2017 Carlos Suárez (https://github.com/bitseater)
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
* Authored by: Carlos Suárez <bitseater@gmail.com>
*/
namespace Weather.Widgets {

    public class Header : Gtk.HeaderBar {

        public Gtk.Button loc_button;
        public Gtk.RadioButton data_but;
        public Gtk.RadioButton maps_but;
        public signal void show_mapwindow ();

        public Header (Weather.MainWindow window, bool view) {
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
            app_button.tooltip_text = _("Options");
            app_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
            menu.show_all ();

            //Right buttons
            loc_button = new Gtk.Button.from_icon_name ("mark-location-symbolic", Gtk.IconSize.BUTTON);
            loc_button.tooltip_text = _("Change location");
            change_visible (false);

            loc_button.clicked.connect (() =>{
                (window.get_child () as Gtk.Widget).destroy ();
                window.add (new Weather.Widgets.City (window, this));
                window.show_all ();
            });
            pack_end (app_button);
            pack_end (loc_button);

            //Left buttons
            data_but = new Gtk.RadioButton.with_label_from_widget (null, _("Data"));
            maps_but = new Gtk.RadioButton.with_label_from_widget (data_but, _("Maps"));
            Gtk.RadioButton[] buttons = {data_but, maps_but};
            var butbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            butbox.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
            butbox.homogeneous = true;
            butbox.hexpand=false;
            foreach (Gtk.Button button in buttons) {
                (button as Gtk.ToggleButton).draw_indicator = false;
                butbox.pack_start (button, false, true, 0);
            }
            data_but.toggled.connect (() => {
                Gtk.Widget child = window.get_child ();
                window.remove (child);
                window.add (new Weather.Widgets.Current (window, this));
                window.show_all ();
            });
            maps_but.toggled.connect (() => {
                this.show_mapwindow ();
            });
            pack_start (butbox);
        }

        public void change_visible (bool s) {
            this.loc_button.sensitive = s;
        }

        public void restart_switcher () {
            this.maps_but.active = false;
            this.data_but.active = true;
        }
    }
}
