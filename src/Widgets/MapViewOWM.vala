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

    public class MapViewOWM : Gtk.Box {

        public MapViewOWM (Weather.MainWindow window, Weather.Widgets.Header header) {
            orientation = Gtk.Orientation.VERTICAL;
            int w;
            int h;
            window.get_size (out w, out h);

            //Define latitude y longitude
            double lat = 0;
            double lon = 0;
            var setting = new Settings ("com.github.bitseater.weather");
            string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
            string apiid = setting.get_string ("apiid");
            string units = setting.get_string ("units");
            string idplace = setting.get_string ("idplace");
            string uriend = "&APPID=" + apiid + "&units=" + units + "&lang=" + lang;
            string uri = Constants.OWM_API_ADDR + "weather?id=" + idplace + uriend;

            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);

            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var root = parser.get_root ().get_object ();
                var coord = root.get_object_member ("coord");
                lat = coord.get_double_member ("lat");
                lon = coord.get_double_member ("lon");
            } catch (Error e) {
                stdout.printf (_("Found an error") + " %s\n", e.message);
            }

            //Define maps URL's and scale images
            string url_serv = "http://tile.openweathermap.org/map/";
            string url_end = "/#Z#/#X#/#Y#.png?appid=" + apiid;
            string url_temp = url_serv + "temp_new" + url_end;
            string url_clou = url_serv + "clouds_new" + url_end;
            string url_prec = url_serv + "precipitation_new" + url_end;
            string url_pres = url_serv + "pressure_new" + url_end;
            string url_wspe = url_serv + "wind_new" + url_end;
            string img_temp = "https://openweathermap.org/img/a/TT.png";
            string img_clou = "https://openweathermap.org/img/a/NT.png";
            string img_prec = "https://openweathermap.org/img/a/RN.png";
            string img_pres = "https://openweathermap.org/img/a/PN.png";
            string img_wspe = "https://openweathermap.org/img/a/UV.png";

            //Define switcher
            var showmap = new Gtk.ScrolledWindow (null, null);
            showmap.hscrollbar_policy = Gtk.PolicyType.NEVER;
            showmap.vscrollbar_policy = Gtk.PolicyType.NEVER;
            var embed = new GtkClutter.Embed();
            embed.use_layout_size = true;
            var stage = (Clutter.Stage) embed.get_stage();
            var view = new Champlain.View ();
            view.add_overlay_source (create_cached_source("TEMP", Champlain.MAP_SOURCE_OWM_TEMPERATURE, url_temp), 200);
            stage.add_child (view);
            view.reactive = true;
            view.set_size (h, h-200);
            view.zoom_level = 8;
            view.max_zoom_level = 12;
            view.min_zoom_level = 2;
            view.kinetic_mode = true;
            view.center_on (lat, lon);
            stage.add_child (create_image (img_temp));
            showmap.add (embed);

            //Define maps switcher
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
                foreach (var item in view.get_overlay_sources ()) {
                    view.remove_overlay_source (item);
                }
                view.add_overlay_source (create_cached_source("TEMP", Champlain.MAP_SOURCE_OWM_TEMPERATURE, url_temp), 200);
                stage.add_child (create_image (img_temp));
            });
            clou_but.toggled.connect (() => {
                foreach (var item in view.get_overlay_sources ()) {
                    view.remove_overlay_source (item);
                }
                view.add_overlay_source (create_cached_source("CLOU", Champlain.MAP_SOURCE_OWM_CLOUDS, url_clou), 200);
                stage.add_child (create_image (img_clou));
            });
            prec_but.toggled.connect (() => {
                foreach (var item in view.get_overlay_sources ()) {
                    view.remove_overlay_source (item);
                }
                view.add_overlay_source (create_cached_source("PREC", Champlain.MAP_SOURCE_OWM_PRECIPITATION, url_prec), 200);
                stage.add_child (create_image (img_prec));
            });
            pres_but.toggled.connect (() => {
                foreach (var item in view.get_overlay_sources ()) {
                    view.remove_overlay_source (item);
                }
                view.add_overlay_source (create_cached_source("PRES", Champlain.MAP_SOURCE_OWM_PRESSURE, url_pres), 200);
                stage.add_child (create_image (img_pres));
            });
            wspe_but.toggled.connect (() => {
                foreach (var item in view.get_overlay_sources ()) {
                    view.remove_overlay_source (item);
                }
                view.add_overlay_source (create_cached_source("WSPE", Champlain.MAP_SOURCE_OWM_WIND, url_wspe), 200);
                stage.add_child (create_image (img_wspe));
            });

            //Define other elements
            string base_lab = _("Change to ");
            var prov_lab = new Gtk.Label ("\xc2\xa9 OpenWeatherMap");
            var tos = new Gtk.LinkButton.with_label ("http://openweathermap.org/terms", _("Terms of Service"));
            tos.halign = Gtk.Align.END;
            var mbutton = new Gtk.Button.with_label (base_lab + " Dark Sky");
            mbutton.clicked.connect (() => {
                    (window.get_child () as Gtk.Widget).destroy ();
                    window.add (new Weather.Widgets.MapView (window, header));
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

        private static Clutter.Actor create_image (string url) {
            Clutter.Actor actor = new Clutter.Actor ();
            try {
                GLib.File imagen = GLib.File.new_for_uri (url);
                InputStream input_stream = imagen.read ();
                var pixbuf = new Gdk.Pixbuf.from_stream_at_scale (input_stream, 72, 202, true);
                var image = new Clutter.Image ();
                image.set_data (pixbuf.get_pixels (),
                          pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                          pixbuf.width,
                          pixbuf.height,
                          pixbuf.rowstride);

                actor.content = image;
                actor.set_size (pixbuf.width, pixbuf.height);
            } catch (Error e) {
                stderr.printf (_("Image not found"));
            }
            return actor;
        }

        public static Champlain.MapSource create_cached_source (string id, string map, string url) {
            var factory = Champlain.MapSourceFactory.dup_default();
            var renderer = new Champlain.ImageRenderer();

            var tile_source = new Champlain.NetworkTileSource.full(
                id,
                map,
                "CC BY-SA 4.0",
                "http://openweathermap.org/terms",
                2,
                12,
                1920,
                Champlain.MapProjection.MERCATOR,
                url,
                renderer);

            var tile_size = tile_source.get_tile_size();

            var error_source = factory.create_error_source(tile_size);
            var file_cache = new Champlain.FileCache.full(100000000, null, renderer);
            var memory_cache = new Champlain.MemoryCache.full(100, renderer);

            var source_chain = new Champlain.MapSourceChain();
            source_chain.push(error_source);
            source_chain.push(tile_source);
            source_chain.push(file_cache);
            source_chain.push(memory_cache);

            return source_chain;
        }
    }
}
