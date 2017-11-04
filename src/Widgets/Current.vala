/*
* Copyright (c) 2017 bitseater (https://github.com/bitseater/weather)
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

    public class Current : Gtk.Grid {

        public Current (Gtk.Window window) {
            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;
            row_spacing = 8;
            column_spacing = 8;
            margin = 12;

            var header = new Weather.Widgets.Header (window, true);
            window.set_titlebar (header);

            var setting = new Settings ("com.github.bitseater.weather");

            string uri = "http://api.openweathermap.org/data/2.5/weather?id=" +
                                setting.get_string ("idplace") + "&APPID=" +
                                setting.get_string ("apiid");

            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);

            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var root = parser.get_root ().get_object ();
                var coord = root.get_object_member ("coord");
                var lon = new Gtk.Label (to_string2 (coord.get_double_member ("lon")));
                var lat = new Gtk.Label (to_string2 (coord.get_double_member ("lat")));
                var weather = root.get_array_member ("weather");
                var weather_id = weather.get_object_element (0).get_int_member ("id");
                var weather_main = new Gtk.Label (weather.get_object_element (0).get_string_member ("main"));
                var descrip = new Gtk.Label (weather.get_object_element (0).get_string_member ("description"));
                var icon = weather.get_object_element (0).get_string_member ("icon");
                var main = root.get_object_member ("main");
                var temp = new Gtk.Label (to_string2 (main.get_double_member ("temp")));
                var pres = new Gtk.Label (main.get_int_member ("pressure").to_string());
                var humid = new Gtk.Label (main.get_int_member ("humidity").to_string ());
                var temp_min = new Gtk.Label (to_string2 (main.get_double_member ("temp_min")));
                var temp_max = new Gtk.Label (to_string2 (main.get_double_member ("temp_max")));
                var wind = root.get_object_member ("wind");
                var speed = new Gtk.Label (to_string2 (wind.get_double_member ("speed")));
                var degrees = new Gtk.Label (to_string2 (wind.get_double_member ("deg")));
                var clouds = root.get_object_member ("clouds");
                var clouds_all = new Gtk.Label (clouds.get_int_member ("all").to_string ());
                var dt = root.get_int_member ("dt");
                var dtime = new DateTime.from_unix_local (dt);
                var datetime = new Gtk.Label (dtime.to_string ());
                var sys = root.get_object_member ("sys");
                string country = sys.get_string_member ("country");
                string city = root.get_string_member("name");

                this.attach (lon, 0, 0, 1, 1);
                this.attach (lat, 0, 1, 1, 1);
                this.attach (weather_main, 0, 2, 1, 1);
                this.attach (descrip, 0, 3, 1, 1);
                this.attach (temp, 0, 4, 1, 1);
                this.attach (pres, 0, 5, 1, 1);
                this.attach (humid, 0, 6, 1, 1);
                this.attach (temp_min, 0, 7, 1, 1);
                this.attach (temp_max, 0, 8, 1, 1);
                this.attach (speed, 0, 9, 1, 1);
                this.attach (degrees, 0, 10, 1, 1);
                this.attach (clouds_all, 0, 11, 1, 1);
                this.attach (datetime, 0, 12, 1, 1);
                header.set_title_header (city, country);
            } catch (Error e) {
                stderr.printf ("Encontrado un error");
            }
        }

        private static string to_string2 (double d) {
            char [] cadena = new char [16];
            d.format (cadena, "%-.2f");
            string texto = (string) cadena;
            return texto;
        }
    }
}
