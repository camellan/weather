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

    public class Apikey : Gtk.Grid {

        private Settings setting;
        private Weather.MainWindow window;

        public Apikey (Weather.MainWindow window, Weather.Widgets.Header header) {
            this.window = window;
            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;
            row_spacing = 10;
            column_spacing = 10;

            setting = new Settings ("com.github.bitseater.weather");
            var units = Weather.Utils.get_units ();
            setting.set_string ("units", units);
            var apilogo = new Gtk.Image.from_icon_name ("avatar-default", Gtk.IconSize.DIALOG);
            apilogo.halign = Gtk.Align.CENTER;
            attach (apilogo, 0, 0, 1, 1);
            var apilabel = new Gtk.Label (_("Enter your OpenWeatherMap API key"));
            apilabel.get_style_context ().add_class ("resumen");
            apilabel.halign = Gtk.Align.CENTER;
            attach (apilabel, 0, 1, 1, 1);
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
            attach (apibox, 0, 2, 1, 1);
            var apilink = new Gtk.Label ("");
            apilink.label = _("If you don't have it, please visit:") + "  <a href =\"https://home.openweathermap.org/users/sign_up\">OpenWeatherMap</a>  " + _("or just :");
            apilink.use_markup = true;
            apilink.get_style_context ().add_class ("comment");
            apilink.halign = Gtk.Align.CENTER;
            attach (new Gtk.Label (" "), 0, 3, 1, 1);
            attach (apilink, 0, 4, 1, 1);
            var apibuild = new Gtk.CheckButton.with_label (_("Use API key built-in"));
            apibuild.halign = Gtk.Align.CENTER;
            attach (apibuild, 0, 5, 1, 1);
            apibuild.toggled.connect (() => {
                if (apibuild.active) {
                    // Button is checked
                    apibutton.sensitive = true;
                    apientry.visibility = false;
                    apientry.set_text (Constants.API_KEY);
                    apientry.sensitive = false;
                    on_select_key ();
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
                        if (setting.get_boolean ("auto")) {
                            Weather.Utils.geolocate ();
                            var current = new Weather.Widgets.Current (window, header);
                            window.change_view (current);
                            window.show_all ();
                        } else {
                            var city = new Weather.Widgets.City (window, header);
                            window.change_view (city);
                            window.show_all ();
                        }
                    } else {
                        window.ticket.title = _("Wrong API Key. Please, try again.");
                        window.ticket.send_notification ();
                        apientry.set_text ("");
                        apibutton.sensitive = false;
                    }
                } else {
                    window.ticket.title = _("The API key cannot be empty.");
                    window.ticket.send_notification ();
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
                debug (e.message);
                return false;
            }
        }

        private void on_select_key () {
            var msg = new Granite.MessageDialog.with_image_from_icon_name (_("Using built-in API key:"), "", "dialog-information", Gtk.ButtonsType.NONE);
            msg.set_transient_for (window);
            string lab1 = ("- " + _("You'll have limited access to API") + "\n- " + _("You can't use the update button") + "\n- " + _("Use only to try this application"));
            msg.secondary_label.label = lab1;
            var closeb = new Gtk.Button.with_label ("Close");
            closeb.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            msg.add_action_widget (closeb, Gtk.ResponseType.CLOSE);
            msg.response.connect (() => {
                msg.destroy ();
            });
            msg.show_all ();
        }
    }
}
