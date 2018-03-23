/*
* Copyright (c) 2017-2018 Carlos Suárez (https://github.com/bitseater)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; If not, see <http://www.gnu.org/licenses/>.
*
* Authored by: Carlos Suárez <bitseater@gmail.com>
*/
namespace Weather {

    public class WeatherApp : Gtk.Application {

        public MainWindow window;

        public WeatherApp () {
            application_id = "com.github.bitseater.weather";
            flags |= GLib.ApplicationFlags.FLAGS_NONE;

            // Localization
            string package_name = Constants.GETTEXT_PACKAGE;
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.textdomain (package_name);
            Intl.bindtextdomain (package_name, Constants.LOCALE_DIR);
            Intl.bind_textdomain_codeset (package_name, "UTF-8");
        }

        public override void activate () {
            if (get_windows () == null) {
                window = new MainWindow (this);
                window.show_all ();
            } else {
                window.present ();
            }
        }

        public static void main (string [] args) {
            GtkClutter.init (ref args);
            var app = new Weather.WeatherApp ();
            app.run (args);
        }
    }
}
