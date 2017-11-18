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

    public class Today : Gtk.Grid {

        public Today (string uri_end) {
            valign = Gtk.Align.START;
            halign = Gtk.Align.CENTER;
            row_spacing = 5;
            column_spacing = 5;
            margin = 15;

            string uri = Constants.OWM_API_ADDR + "weather?id=" + uri_end;

            var setting = new Settings ("com.github.bitseater.weather");
            var units = setting.get_string ("units");
            string temp_un = "";
            string speed_un = "";
            if (units != "metric") {
                temp_un = "F";
                speed_un = " mph";
            } else {
                temp_un = "C";
                speed_un = " m/s";
            }

            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);

            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var today = new Gtk.Label (_("Today"));
                today.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
                today.halign = Gtk.Align.START;
                var root = parser.get_root ().get_object ();
                var coord = root.get_object_member ("coord");
                var coord_lb = new Gtk.Label (_("Coordinates :"));
                coord_lb.halign = Gtk.Align.END;
                string lon = "";
                if(coord.get_double_member ("lon") > 0) {
                    lon = Weather.Utils.to_string2 (coord.get_double_member ("lon")) + "W";
                } else {
                    lon = Weather.Utils.to_string2 ((coord.get_double_member ("lon"))*-1) + "E";
                }
                string lat = "";
                if(coord.get_double_member ("lat") > 0) {
                    lat = Weather.Utils.to_string2 (coord.get_double_member ("lat")) + "N";
                } else {
                    lat = Weather.Utils.to_string2 ((coord.get_double_member ("lat"))*-1) + "S";
                }
                var coord_c = new Gtk.Label ("[ " + lon + " , " + lat + " ]");
                coord_c.halign = Gtk.Align.START;
                var weather = root.get_array_member ("weather");
                var weather_main = new Gtk.Label (weather.get_object_element (0).get_string_member ("main") + ", "
                                                + weather.get_object_element (0).get_string_member ("description"));
                weather_main.halign = Gtk.Align.START;
                weather_main.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
                var icon = new Weather.Utils.Iconame (weather.get_object_element (0).get_string_member ("icon"), 128);
                icon.halign = Gtk.Align.END;
                icon.valign = Gtk.Align.START;
                var main = root.get_object_member ("main");
                var temp = new Gtk.Label (Weather.Utils.to_string0 (main.get_double_member ("temp")) + "\u00B0" + temp_un);
                temp.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
                temp.halign = Gtk.Align.START;
                var pres = new Gtk.Label (main.get_int_member ("pressure").to_string() + " hPa");
                pres.halign = Gtk.Align.START;
                var pres_lb = new Gtk.Label (_("Pressure :"));
                pres_lb.halign = Gtk.Align.END;
                var humid = new Gtk.Label (main.get_int_member ("humidity").to_string () + " %");
                humid.halign = Gtk.Align.START;
                var humid_lb = new Gtk.Label (_("Humidity :"));
                humid_lb.halign = Gtk.Align.END;
                var wind = root.get_object_member ("wind");
                var speed = new Gtk.Label (Weather.Utils.to_string0 (wind.get_double_member ("speed")) + speed_un);
                speed.halign = Gtk.Align.START;
                var speed_lb = new Gtk.Label (_("Wind speed :"));
                speed_lb.halign = Gtk.Align.END;
                var degrees = new Gtk.Label (Weather.Utils.to_string0 (wind.get_double_member ("deg")) + "\u00B0");
                degrees.halign = Gtk.Align.START;
                var degrees_lb = new Gtk.Label (_("Wind dir :"));
                degrees_lb.halign = Gtk.Align.END;
                var clouds = root.get_object_member ("clouds");
                var clouds_all = new Gtk.Label (clouds.get_int_member ("all").to_string () + " %");
                clouds_all.halign = Gtk.Align.START;
                var clouds_lb = new Gtk.Label (_("Cloudiness :"));
                clouds_lb.halign = Gtk.Align.END;
                var sun_r = new Gtk.Label (_("Sunrise :"));
                sun_r.halign = Gtk.Align.END;
                var sunr = new DateTime.from_unix_local (root.get_object_member ("sys").get_int_member ("sunrise"));
                var sunrise = new Gtk.Label (sunr.format ("%R UTC%z").to_string ());
                sunrise.halign = Gtk.Align.START;
                var sun_s = new Gtk.Label (_("Sunset :"));
                sun_s.halign = Gtk.Align.END;
                var suns = new DateTime.from_unix_local (root.get_object_member ("sys").get_int_member ("sunset"));
                var sunset = new Gtk.Label (suns.format ("%R UTC%z").to_string ());
                sunset.halign = Gtk.Align.START;

                attach (today, 0, 0, 2, 1);
                attach (weather_main, 0, 1, 2, 1);
                attach (temp, 0, 2, 2, 1);
                attach (icon, 3, 0, 3, 3);
                attach (new Gtk.Label (" "), 1, 3, 2, 1);
                attach (pres_lb, 1, 4, 2, 1);
                attach (pres, 3, 4, 2, 1);
                attach (humid_lb, 1, 5, 2, 1);
                attach (humid, 3, 5, 2, 1);
                attach (speed_lb, 1, 6, 2, 1);
                attach (speed, 3, 6, 2, 1);
                attach (degrees_lb, 1, 7, 2, 1);
                attach (degrees, 3, 7, 2, 1);
                attach (clouds_lb, 1, 8, 2, 1);
                attach (clouds_all, 3, 8, 2, 1);
                attach (coord_lb, 1, 9, 2, 1);
                attach (coord_c, 3, 9, 2, 1);
                attach (sun_r, 1, 10, 2, 1);
                attach (sunrise, 3, 10, 2, 1);
                attach (sun_s, 1, 11, 2, 1);
                attach (sunset, 3, 11, 2, 1);
            } catch (Error e) {
                stderr.printf (_("Found an error"));
            }
        }
    }
}
