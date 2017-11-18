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
namespace  Weather.Widgets {

    public class Forecast : Gtk.Grid {

        public Forecast (string uri_end) {
            valign = Gtk.Align.START;
            halign = Gtk.Align.CENTER;
            row_spacing = 5;
            column_spacing = 10;
            column_homogeneous = true;
            margin = 15;

            string uri = Constants.OWM_API_ADDR + "forecast?id=" + uri_end;

            var setting = new Settings ("com.github.bitseater.weather");
            var units = setting.get_string ("units");
            string temp_un = "";
            if (units != "metric") {
                temp_un = "F";
            } else {
                temp_un = "C";
            }

            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);
            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var forecast = new Gtk.Label (_("Forecast"));
                forecast.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
                forecast.halign = Gtk.Align.START;
                attach (forecast, 0, 0, 2, 1);
                var root = parser.get_root ().get_object ();
                var list = root.get_array_member ("list");
                for (int a = 0; a < 5; a++) {
                    var time = new Gtk.Label (new DateTime.from_unix_local (list.get_object_element (a).get_int_member ("dt")).format ("%H:%M").to_string ());
                    var icon = new Weather.Utils.Iconame (list.get_object_element(a).get_array_member ("weather").get_object_element (0).get_string_member ("icon"), 36);
                    var temp = new Gtk.Label (Weather.Utils.to_string0 (list.get_object_element(a).get_object_member ("main").get_double_member ("temp")) + "\u00B0" + temp_un);
                    attach (time, a, 1, 2, 1);
                    attach (icon, a, 2, 2, 1);
                    attach (temp, a, 3, 2, 1);
                }
                attach (new Gtk.Label (" "), 1, 4, 1, 1);
                for (int b = 0; b < 5; b++) {
                    var time = new Gtk.Label (new DateTime.from_unix_local (list.get_object_element (b*8+7).get_int_member ("dt")).format ("%a").to_string ());
                    var icon = new Weather.Utils.Iconame (list.get_object_element(b*8+7).get_array_member ("weather").get_object_element (0).get_string_member ("icon"), 36);
                    var temp = new Gtk.Label (Weather.Utils.to_string0 (list.get_object_element(b*8+7).get_object_member ("main").get_double_member ("temp")) + "\u00B0" + temp_un);
                    attach (time, 1, 5+b, 2, 1);
                    attach (icon, 2, 5+b, 2, 1);
                    attach (temp, 3, 5+b, 2, 1);
                }
            } catch (Error e) {
                stderr.printf (_("Found an error"));
            }
        }
    }
}
