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
namespace Weather.Widgets {

    public class MapView : Gtk.Box {

        public MapView (Weather.MainWindow window, Weather.Widgets.Header header) {
            orientation = Gtk.Orientation.VERTICAL;

            //Define latitude y longitude and units
            string lat = "";
            string lon = "";
            var setting = new Settings ("com.github.bitseater.weather");
            string apiid = setting.get_string ("apiid");
            string units = setting.get_string ("units");
            string idplace = setting.get_string ("idplace");
            string uri = Constants.OWM_API_ADDR + "weather?id=" + idplace + "&APPID=" + apiid;
            string temp_un = "";
            string prec_un = "";
            string pres_un = "";
            string wspe_un = "";
            switch (units) {
                case "metric":
                    temp_un = "_c";
                    prec_un = "_mmph";
                    pres_un = "_hpa";
                    wspe_un = "_kmph";
                    break;
                case "imperial":
                    temp_un = "_f";
                    prec_un = "_inph";
                    pres_un = "_inhg";
                    wspe_un = "_mph";
                    break;
                case "british":
                    temp_un = "_c";
                    prec_un = "_inph";
                    pres_un = "_hpa";
                    wspe_un = "_mph";
                    break;
                default:
                    temp_un = "_c";
                    prec_un = "_mmph";
                    pres_un = "_hpa";
                    wspe_un = "_kmph";
                    break;
            }

            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);

            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var root = parser.get_root ().get_object ();
                var coord = root.get_object_member ("coord");
                lat = Weather.Utils.to_string2 (coord.get_double_member ("lat"));
                lon = Weather.Utils.to_string2 (coord.get_double_member ("lon"));
            } catch (Error e) {
                stdout.printf (_("Found an error") + ": %s\n", e.message);
            }

            //Define maps URL's
            string url_serv = "https://maps.darksky.net/@";
            string url_med = ",8?embed=true&timeControl=false&fieldControl=false&defaultField=";
            string url_temp = url_serv + "temperature," + lat + "," + lon + url_med + "temperature&defaultUnits=" + temp_un;
            string url_clou = url_serv + "cloud_cover," + lat + "," + lon + url_med + "cloud_cover";
            string url_prec = url_serv + "precipitation_rate," + lat + "," + lon + url_med + "precipitation_rate&defaultUnits=" + prec_un;
            string url_pres = url_serv + "sea_level_pressure," + lat + "," + lon + url_med + "sea_level_pressure&defaultUnits=" + pres_un;
            string url_wspe = url_serv + "wind_speed," + lat + "," + lon + url_med + "wind_speed&defaultUnits=" + wspe_un;

            //Define switcher
            var showmap = new Gtk.Stack ();
            showmap.transition_type = Gtk.StackTransitionType.CROSSFADE;
            showmap.transition_duration = 1000;
            var switchmap = new Gtk.StackSwitcher ();
            switchmap.stack = showmap;
            switchmap.homogeneous = true;

            showmap.add_titled (new Weather.Utils.MapLayer (url_temp), "TEMP", _("Temperature"));
            showmap.add_titled (new Weather.Utils.MapLayer (url_clou), "CLOU", _("Clouds"));
            showmap.add_titled (new Weather.Utils.MapLayer (url_prec), "PREC", _("Precipitation"));
            showmap.add_titled (new Weather.Utils.MapLayer (url_pres), "PRES", _("Pressure"));
            showmap.add_titled (new Weather.Utils.MapLayer (url_wspe), "WSPE", _("Wind Speed"));

            //Define other elements
            string base_lab = _("Change to ");
            var prov_lab = new Gtk.Label ("\xc2\xa9 Dark Sky");
            var tos = new Gtk.LinkButton.with_label ("https://darksky.net/widgetterms", _("Terms of Service"));
            tos.halign = Gtk.Align.END;
            var mbutton = new Gtk.Button.with_label (base_lab + "OpenWeatherMap");
            mbutton.clicked.connect (() => {
                    window.change_view (new Weather.Widgets.MapViewOWM (window, header));
                    window.show_all ();
            });
            //Pack combo to actionbar
            var prov_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 3);
            prov_box.margin = 3;
            prov_box.pack_start (prov_lab , false, false, 3);
            prov_box.pack_end (tos, false, false, 3);
            var map_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 3);
            map_box.margin = 3;
            map_box.pack_end (mbutton, false, false, 3);
            var action_box = new Gtk.ActionBar ();
            action_box.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
            action_box.pack_start (prov_box);
            action_box.pack_end (map_box);

            //Pack elementes
            pack_start (switchmap, false, false , 0);
            pack_start (showmap, true, true, 0);
            pack_end (action_box, false, false, 0);
        }
    }
}
