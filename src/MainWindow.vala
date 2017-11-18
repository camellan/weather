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

        public WeatherApp app;

        public MainWindow (WeatherApp app) {
            this.app = app;
            this.set_application (app);
            this.set_default_size (750, 590);
            this.set_size_request (750, 590);
            window_position = Gtk.WindowPosition.CENTER;
            var header = new Weather.Widgets.Header (this, false);
            this.set_titlebar (header);

            var setting = new Settings ("com.github.bitseater.weather");
            setting.get_boolean ("dark");
            if (setting.get_boolean ("dark")) {
                Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
            } else {
                Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
            }

            // Set main content
            if (setting.get_string ("apiid") == "") {
                var apikey = new Weather.Widgets.Apikey (this, header);
                this.add (apikey);
            } else if (setting.get_string ("idplace") == "") {
                var city = new Weather.Widgets.City (this, header);
                this.add (city);
            } else {
                var current = new Weather.Widgets.Current (this, header);
                this.add (current);
            }
            this.show_all ();
        }
    }
}
