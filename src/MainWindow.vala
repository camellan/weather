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
namespace Weather {

    public class MainWindow : Gtk.Window {

        public WeatherApp app;
        public AppIndicator.Indicator indicator;

        public MainWindow (WeatherApp app) {
            this.app = app;
            this.set_application (app);
            this.set_default_size (750, 590);
            this.set_size_request (750, 590);
            window_position = Gtk.WindowPosition.CENTER;
            var header = new Weather.Widgets.Header (this, false);
            this.set_titlebar (header);

            //Define style
            string weather_css = """
                .temp {
                    font-size: 250%;
                    font-weight: 500;
                }
                .weather {
                    font-size: 170%;
                }
                .resumen {
                    font-size: 110%;
                }
                .preferences {
                    font-size: 110%;
                    font-weight: 600;
                }
                .ticket {
                    background-color: @text-color;
                    color: @background_color;
                    opacity: 0.5;
                }
                .ticket:hover {
                    opacity: 1.0;
                }
            """;
            var provider = new Gtk.CssProvider();
            try {
                provider.load_from_data (weather_css, -1);
            } catch (GLib.Error e) {
                GLib.error ("Failed to load css: %s", e.message);
            }
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            var setting = new Settings ("com.github.bitseater.weather");
            setting.get_boolean ("dark");
            if (setting.get_boolean ("dark")) {
                Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
            } else {
                Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
            }

            //Create indicator and show if true:
            create_indicator ();
            if (setting.get_boolean ("indicator")) {
                show_indicator ();
            } else {
                hide_indicator ();
            }
            this.delete_event.connect (() => {
                 if (setting.get_boolean ("indicator")) {
                    this.hide_on_delete ();
                } else {
                    (app as GLib.Application).quit ();
                }
                return true;
            });

            // Set main content
            if (setting.get_string ("apiid") == "") {
                var apikey = new Weather.Widgets.Apikey (this, header);
                this.add (apikey);
            } else if (setting.get_boolean ("auto")) {
                Weather.Utils.geolocate ();
                var current = new Weather.Widgets.Current (this, header);
                this.add (current);
            } else if (setting.get_string ("idplace") == "") {
                var city = new Weather.Widgets.City (this, header);
                this.add (city);
            } else {
                var current = new Weather.Widgets.Current (this, header);
                this.add (current);
            }
            this.show_all ();
        }

        public void set_icolabel (string icon, string label) {
            this.indicator.set_icon_full (icon, icon);
            this.indicator.label = label;
        }

        public void create_indicator () {
            indicator = new AppIndicator.Indicator ("weather", "weather-few-clouds-symbolic",
                                    AppIndicator.IndicatorCategory.APPLICATION_STATUS);
            indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);

            var menu = new Gtk.Menu();
            var show_item = new Gtk.MenuItem.with_label (_("Show Weather"));
            show_item.activate.connect(() => {
                this.get_focus ();
                this.show_all ();
            });
            show_item.show();
            menu.append(show_item);

            var quit_item = new Gtk.MenuItem.with_label (_("Quit"));
            quit_item.show();
            quit_item.activate.connect(() => {
                (app as GLib.Application).quit ();
            });
            menu.append(quit_item);
            indicator.set_menu(menu);
            indicator.set_secondary_activate_target(quit_item);
        }

        public void show_indicator () {
            indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);
        }

        public void hide_indicator () {
            indicator.set_status(AppIndicator.IndicatorStatus.PASSIVE);
        }
    }
}
