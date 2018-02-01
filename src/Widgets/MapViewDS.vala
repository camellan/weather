/*
* Copyright (c) 2018 Carlos Suárez (https://github.com/bitseater)
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

    public class MapViewDS : Gtk.Box {

        public MapViewDS (Gtk.Window window, Weather.Widgets.Header header) {
            orientation = Gtk.Orientation.VERTICAL;

            //Define latitude y longitude and units
            string lat = "";
            string lon = "";
            var setting = new Settings ("com.github.bitseater.weather");
            string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
            string apiid = setting.get_string ("apiid");
            string units = setting.get_string ("units");
            string idplace = setting.get_string ("idplace");
            string uriend = "&APPID=" + apiid + "&units=" + units + "&lang=" + lang;
            string uri = Constants.OWM_API_ADDR + "weather?id=" + idplace + uriend;
            string temp_un = "";
            string prec_un = "";
            string pres_un = "";
            string wspe_un = "";
            if (units != "metric") {
                temp_un = "_f";
                prec_un = "_inph";
                pres_un = "_inhg";
                wspe_un = "_mph";
            } else {
                temp_un = "_c";
                prec_un = "_mmph";
                pres_un = "_hpa";
                wspe_un = "_kmph";
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
                stdout.printf ("Hubo un error: %s\n", e.message);
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
            var showmap = new Gtk.ScrolledWindow (null, null);
            showmap.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            showmap.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            showmap.add (new Weather.Utils.MapLayer (url_temp));
            var temp_but = new Gtk.RadioButton.with_label_from_widget (null, _("Temperature"));
            var clou_but = new Gtk.RadioButton.with_label_from_widget (temp_but, _("Clouds"));
            var prec_but = new Gtk.RadioButton.with_label_from_widget (temp_but, _("Precipitation"));
            var pres_but = new Gtk.RadioButton.with_label_from_widget (temp_but, _("Pressure"));
            var wspe_but = new Gtk.RadioButton.with_label_from_widget (temp_but,  _("Wind Speed"));
            Gtk.RadioButton[] buttons = {temp_but, clou_but, prec_but, pres_but, wspe_but};
            var switchmap = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            switchmap.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
            switchmap.homogeneous = true;
            switchmap.hexpand=true;
            foreach (Gtk.Button button in buttons) {
                (button as Gtk.ToggleButton).draw_indicator = false;
                switchmap.pack_start (button, false, true, 0);
            }
            temp_but.toggled.connect (() => {
                show_map (showmap, url_temp);
            });
            clou_but.toggled.connect (() => {
                show_map (showmap, url_clou);
            });
            prec_but.toggled.connect (() => {
                show_map (showmap, url_prec);
            });
            pres_but.toggled.connect (() => {
                show_map (showmap, url_pres);
            });
            wspe_but.toggled.connect (() => {
                show_map (showmap, url_wspe);
            });

            //Define other elements
            var provider = new Gtk.ComboBoxText ();
            provider.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
            provider.append_text (_("Dark Sky"));
            provider.append_text (_("OpenWeatherMap"));
            provider.active = 0;
            provider.changed.connect (() => {
                if (provider.active == 1) {
                    window.remove (window.get_child ());
                    window.add (new Weather.Widgets.MapViewOWM (window, header));
                    window.show_all ();
                } else {
                    window.remove (window.get_child ());
                    window.add (new Weather.Widgets.MapViewDS (window, header));
                    window.show_all ();
                }
            });
            var tos = new Gtk.LinkButton.with_label ("https://darksky.net/widgetterms", _("Terms of Service"));
            tos.halign = Gtk.Align.END;
            var prov_lab = new Gtk.Label (_("Provider by :"));
            //Pack combo to actionbar
            var prov_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 3);
            prov_box.margin = 3;
            prov_box.pack_start (prov_lab, false, false, 3);
            prov_box.pack_start (provider, false, false, 3);
            prov_box.pack_end (tos, false, false, 3);
            var action_box = new Gtk.ActionBar ();
            action_box.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
            action_box.pack_start (prov_box);

            //Pack elementes
            pack_start (switchmap, false, false , 0);
            pack_start (showmap, true, true, 0);
            pack_end (action_box, false, false, 0);
        }

        private void show_map (Gtk.ScrolledWindow scroll, string url) {
            scroll.remove (scroll.get_child ());
            scroll.add (new Weather.Utils.MapLayer (url));
            scroll.show_all ();
        }
    }
}
