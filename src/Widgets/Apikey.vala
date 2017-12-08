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
namespace  Weather.Widgets {

    public class Apikey : Gtk.Overlay {

        private Settings setting;

        public Apikey (Gtk.Window window, Weather.Widgets.Header header) {
            var grid = new Gtk.Grid ();
            grid.valign = Gtk.Align.CENTER;
            grid.halign = Gtk.Align.CENTER;
            grid.row_spacing = 10;
            grid.column_spacing = 10;
            add_overlay (grid);

            setting = new Settings ("com.github.bitseater.weather");
            var units = Weather.Utils.get_units ();
            setting.set_string ("units", units);
            var ticket = new Weather.Widgets.Ticket ("");
            add_overlay (ticket);
            var apilogo = new Gtk.Image.from_icon_name ("avatar-default", Gtk.IconSize.DIALOG);
            apilogo.halign = Gtk.Align.CENTER;
            grid.attach (apilogo, 0, 0, 1, 1);
            var apilabel = new Gtk.Label (_("<big>Enter your OpenWeatherMap API key</big>\n"));
            apilabel.use_markup = true;
            apilabel.halign = Gtk.Align.CENTER;
            grid.attach (apilabel, 0, 1, 1, 1);
            var apibox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            var apientry = new Gtk.Entry ();
            apientry.width_chars = 35;
            apientry.set_text ("");
            apientry.halign = Gtk.Align.END;
            var apibutton = new Gtk.Button.with_label (_("Save"));
            apibutton.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            apibutton.halign = Gtk.Align.START;
            apibutton.sensitive = false;
            apientry.changed.connect (() => {
                apibutton.sensitive = true;
            });
            apibox.pack_start (apientry, true, false, 0);
            apibox.pack_start (apibutton, false, false, 0);
            grid.attach (apibox, 0, 2, 1, 1);
            var apilink = new Gtk.Label ("");
            apilink.label = _("<small>If you don't have it, please visit: <a href =\"https://home.openweathermap.org/users/sign_up\">OpenWeatherMap</a> or just :</small>");
            apilink.use_markup = true;
            apilink.halign = Gtk.Align.CENTER;
            grid.attach (new Gtk.Label (" "), 0, 3, 1, 1);
            grid.attach (apilink, 0, 4, 1, 1);
            var apibuild = new Gtk.CheckButton.with_label (_("Use API key built-in"));
            apibuild.halign = Gtk.Align.CENTER;
            grid.attach (apibuild, 0, 5, 1, 1);
            apibuild.toggled.connect (() => {
                if (apibuild.active) {
                // Button is checked
                apibutton.sensitive = true;
                apientry.visibility = false;
                apientry.set_text ("936b1aed9a541e3446cafb8be2c70e62");
                apientry.sensitive = false;
                } else {
                // Button is not checked
                apientry.visibility = true;
                apientry.set_text ("");
                apientry.sensitive = true;
                apibutton.sensitive = false;
                }
            });
            apibutton.clicked.connect (() => {
                if (apientry.get_text () != "") {
                    string uri = Constants.OWM_API_ADDR + "weather?id=2643743&appid=" + apientry.get_text ();
                    if (check_apikey (uri)) {
                        setting.set_string ("apiid", apientry.get_text ());
                        if (setting.get_boolean ("auto")){
                            Weather.Utils.geolocate ();
                            window.remove (window.get_child ());
                            var current = new Weather.Widgets.Current (window, header);
                            window.add (current);
                            window.show_all ();
                        } else {
                            window.remove (window.get_child ());
                            var city = new Weather.Widgets.City (window, header);
                            window.add (city);
                            window.show_all ();
                        }
                    } else {
                        ticket.set_text (_("Wrong API Key. Please, try again."));
                        ticket.reveal_child = true;
                        apientry.set_text ("");
                        apibutton.sensitive = false;
                    }
                } else {
                    ticket.set_text (_("The API key cannot be empty."));
                    ticket.reveal_child = true;
                }
            });
        }

        private bool check_apikey (string uri) {
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.send_message (message);
            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                var root = parser.get_root ().get_object ();
                var code = root.get_int_member ("cod");
                if (code != 200) {
                    return false;
                } else {
                    return true;
                }
            } catch (Error e) {
                stderr.printf (_("Found an error"));
                return false;
            }
        }
    }
}
