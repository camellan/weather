/*
* Copyright (c) 2016 bitseater (https://github.com/bitseater/weather)
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
namespace Weather {

    public class MainWindow : Gtk.Window {

        Gtk.Stack mainstack;
        Gtk.HeaderBar header;
        Settings setting;

        public WeatherApp app;

        public MainWindow (WeatherApp app) {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
            this.app = app;
            this.set_application (app);
            this.set_default_size (750, 600);
            window_position = Gtk.WindowPosition.CENTER;

            setting = new Settings ("com.github.bitseater.weather");

            // Set main content
            mainstack = new Gtk.Stack ();
            mainstack.transition_type = Gtk.StackTransitionType.SLIDE_DOWN;
            if (setting.get_string ("apiid") == "") {
                var apikey = new Weather.Widgets.Apikey (this);
                mainstack.add_named (apikey, "apikey");
                mainstack.set_visible_child_name ("apikey");
            } else if (setting.get_string ("idplace") != "") {
                create_main ();
                mainstack.set_visible_child_name ("main");
            } else {
                create_welcome ();
                create_location ();
                create_main ();
                mainstack.set_visible_child_name ("welcome");
            }

            // Add everything to window
            this.add (mainstack);
            this.show_all ();
        }

        private void create_main () {
            var setting = new Settings ("com.github.bitseater.weather");
            header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            header.get_style_context ().add_class ("compact");
            var menu = new Gtk.Menu ();
            var app_menu = app.create_appmenu (menu);
            header.pack_end (app_menu);
            header.title = setting.get_string ("idplace");
            this.set_titlebar (header);
            var mainbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 1);
            mainbox.homogeneous = true;
            mainbox.pack_start (new Gtk.Label ("izq"), true, true, 1);
            mainbox.pack_start (new Gtk.Label ("der"), true, true, 1);
            mainstack.add_named (mainbox, "main");
        }

        private void create_welcome () {
            var welcome = new Granite.Widgets.Welcome ("Welcome to Weather", "A forecast application for elementary OS");
            welcome.append ("preferences-system-network", "Add place", "Select your current location");

            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        mainstack.set_visible_child_name ("location");
                        break;
                    }
                });
            mainstack.add_named (welcome, "welcome");
        }

        private void create_location () {
            var city = new Weather.Widgets.City (this);
            mainstack.add_named (city, "location");
        }
    }
}
