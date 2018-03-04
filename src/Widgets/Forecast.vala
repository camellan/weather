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
namespace  Weather.Widgets {

    public class Forecast : Gtk.Grid {

        public Forecast (string idplace) {
            valign = Gtk.Align.START;
            halign = Gtk.Align.CENTER;
            row_spacing = 5;
            column_spacing = 10;
            column_homogeneous = true;
            margin = 15;

            var setting = new Settings ("com.github.bitseater.weather");
            string apiid = setting.get_string ("apiid");
            string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
            string unit = setting.get_string ("units");
            string units = "";
            string temp_un = "";
            switch (unit) {
                case "metric":
                    temp_un = "C";
                    units = "metric";
                    break;
                case "imperial":
                    temp_un = "F";
                    units = "imperial";
                    break;
                case "british":
                    temp_un = "C";
                    units = "imperial";
                    break;
                default:
                    temp_un = "C";
                    units = "metric";
                    break;
            }

            string uri_end = idplace + "&APPID=" + apiid + "&units=" + units + "&lang=" + lang;
            string uri = Constants.OWM_API_ADDR + "forecast?id=" + uri_end;
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);
            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var forecast = new Gtk.Label (_("Forecast"));
                forecast.get_style_context ().add_class ("weather");
                forecast.halign = Gtk.Align.START;
                attach (forecast, 0, 0, 2, 1);
                var root = parser.get_root ().get_object ();
                var list = root.get_array_member ("list");
                for (int a = 0; a < 5; a++) {
                    var time = new Gtk.Label (time_format (new DateTime.from_unix_local (list.get_object_element (a).get_int_member ("dt"))));
                    var icon = new Weather.Utils.Iconame (list.get_object_element(a).get_array_member ("weather").get_object_element (0).get_string_member ("icon"), 36);
                    double temp_n = list.get_object_element(a).get_object_member ("main").get_double_member ("temp");
                    var temp = new Gtk.Label ("");
                    switch (unit) {
                            case "british":
                                temp.label = Weather.Utils.to_string0 (((temp_n - 32)*5)/9) + "\u00B0" + temp_un;
                                break;
                            case "metric":
                            case "imperial":
                            default:
                                temp.label = Weather.Utils.to_string0 (temp_n) + "\u00B0" + temp_un;
                                break;
                        }
                    attach (time, a, 1, 1, 1);
                    attach (icon, a, 2, 1, 1);
                    attach (temp, a, 3, 1, 1);
                }
                attach (new Gtk.Label (" "), 1, 4, 1, 1);
                int cnt = ((int) root.get_int_member ("cnt") - 33);
                for (int b = 0; b < 5; b++) {
                    var time = new Gtk.Label (new DateTime.from_unix_local (list.get_object_element (b*8+cnt).get_int_member ("dt")).format ("%a %H:%M"));
                    var icon = new Weather.Utils.Iconame (list.get_object_element(b*8+cnt).get_array_member ("weather").get_object_element (0).get_string_member ("icon"), 36);
                    double temp_n = list.get_object_element(b*8+cnt).get_object_member ("main").get_double_member ("temp");
                    var temp = new Gtk.Label ("");
                    switch (unit) {
                            case "british":
                                temp.label = Weather.Utils.to_string0 (((temp_n - 32)*5)/9) + "\u00B0" + temp_un;
                                break;
                            case "metric":
                            case "imperial":
                            default:
                                temp.label = Weather.Utils.to_string0 (temp_n) + "\u00B0" + temp_un;
                                break;
                        }
                    attach (time, 0, 5+b, 2, 1);
                    attach (icon, 2, 5+b, 1, 1);
                    attach (temp, 3, 5+b, 2, 1);

                    //Record data
                    var file = new File.new_for_path (Environment.get_user_cache_dir () + "/" + Constants.EXEC_NAME + "/" + "forecast.json");
                    if (file.query_exists ()) {
                        file.delete ();
                    }

                }
            } catch (Error e) {
                debug (e.message);
            }
        }

        private string time_format (GLib.DateTime datetime) {
            string timeformat = "";
            var syssetting = new Settings ("org.gnome.desktop.interface");
            if (syssetting.get_string ("clock-format") == "12h") {
                timeformat = datetime.format ("%I:%M");
            } else {
                timeformat = datetime.format ("%R");
            }
            return timeformat;
        }
    }
}
