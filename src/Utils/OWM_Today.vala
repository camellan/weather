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
namespace  Weather.Utils {

    public class OWM_Today : Object {

        private string _coor_lon;
        private string _coor_lat;
        private string _wmain;
        private string _wdescrip;
        private string _icon;
        private string _temp;
        private string _pressure;
        private string _humidity;
        private string _winddir;
        private string _windspeed;
        private string _clouds;
        private string _sunrise;
        private string _sunset;

        public string coor_lon {
            get{return _coor_lon;}
            set{_coor_lon = value;}
        }

        public string coor_lat {
            get{return _coor_lat;}
            set{_coor_lat = value;}
        }

        public string wmain {
            get{return _wmain;}
            set{_wmain = value;}
        }

        public string wdescrip {
            get{return _wdescrip;}
            set{_wdescrip = value;}
        }

        public string icon {
            get{return _icon;}
            set{_icon = value;}
        }

        public string temp {
            get{return _temp;}
            set{_temp = value;}
        }

        public string pressure {
            get{return _pressure;}
            set{_pressure = value;}
        }

        public string humidity {
            get{return _humidity;}
            set{_humidity = value;}
        }

        public string winddir {
            get{return _winddir;}
            set{_winddir = value;}
        }

        public string windspeed {
            get{return _windspeed;}
            set{_windspeed = value;}
        }

        public string clouds {
            get{return _clouds;}
            set{_clouds = value;}
        }

        public string sunrise {
            get{return _sunrise;}
            set{_sunrise = value;}
        }

        public string sunset {
            get{return _sunset;}
            set{_sunset = value;}
        }

        public OWM_Today (string idplace) {
            var setting = new Settings ("com.github.bitseater.weather");
            string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
            string apiid = setting.get_string ("apiid");
            string units = setting.get_string ("units");
            string uriend = "&APPID=" + apiid + "&units=" + units + "&lang=" + lang;
            string uri = Constants.OWM_API_ADDR + "weather?id=" + idplace + uriend;
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

                var root = parser.get_root ().get_object ();
                var coord = root.get_object_member ("coord");
                if(coord.get_double_member ("lon") > 0) {
                    _coor_lon = Weather.Utils.to_string2 (coord.get_double_member ("lon")) + "W";
                } else {
                    _coor_lon = Weather.Utils.to_string2 ((coord.get_double_member ("lon"))*-1) + "E";
                }
                if(coord.get_double_member ("lat") > 0) {
                    _coor_lat = Weather.Utils.to_string2 (coord.get_double_member ("lat")) + "N";
                } else {
                    _coor_lat = Weather.Utils.to_string2 ((coord.get_double_member ("lat"))*-1) + "S";
                }
                var weather = root.get_array_member ("weather");
                _wmain = weather.get_object_element (0).get_string_member ("main");
                _wdescrip = weather.get_object_element (0).get_string_member ("description");
                //Fix problems with cyrilic characters
                if (lang != "ru") {
                    _wdescrip = _wdescrip.up (1) + _wdescrip.substring (1, -1);
                }
                _icon = weather.get_object_element (0).get_string_member ("icon");
                var vmain = root.get_object_member ("main");
                _temp = Weather.Utils.to_string0 (vmain.get_double_member ("temp")) + "\u00B0" + temp_un;
                _pressure = vmain.get_int_member ("pressure").to_string() + " hPa";
                _humidity = vmain.get_int_member ("humidity").to_string () + " %";
                var wind = root.get_object_member ("wind");
                _windspeed = Weather.Utils.to_string0 (wind.get_double_member ("speed")) + speed_un;
                _winddir = cardinal (wind.get_double_member ("deg"));
                var clouds = root.get_object_member ("clouds");
                _clouds = clouds.get_int_member ("all").to_string () + " %";
                var sunr = new DateTime.from_unix_local (root.get_object_member ("sys").get_int_member ("sunrise"));
                _sunrise = time_format (sunr);
                var suns = new DateTime.from_unix_local (root.get_object_member ("sys").get_int_member ("sunset"));
                _sunset = time_format (suns);

            } catch (Error e) {
                stdout.printf ("Hubo un error: %s\n", e.message);
            }
        }

        private string time_format (GLib.DateTime datetime) {
            string timeformat = "";
            var syssetting = new Settings ("org.gnome.desktop.interface");
            if (syssetting.get_string ("clock-format") == "12h") {
                timeformat = datetime.format ("%I:%M UTC%z");
                if (datetime.get_hour () >= 12) {
                    timeformat = timeformat + " PM";
                } else {
                    timeformat = timeformat + " AM";
                }
            } else {
                timeformat = datetime.format ("%R UTC%z");
            }
            return timeformat;
        }

        private string cardinal(double grados) {
            double val = Math.floor((grados / 22.5) + 0.5);
            string[] arr = {"N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"};
            int index = (int)(val % 16);
            return arr[index];
        }
    }
}
