/*
* Copyright (c) 2016 bitseater (https://github.com/bitseater/weather)
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

    public class Apikey : Gtk.Grid {

        private Settings setting;

        public Apikey (Gtk.Window window, Weather.Widgets.Header header) {
            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;
            row_spacing = 10;
            column_spacing = 10;

            setting = new Settings ("com.github.bitseater.weather");
            var apilogo = new Gtk.Image.from_icon_name ("avatar-default", Gtk.IconSize.DIALOG);
            apilogo.halign = Gtk.Align.CENTER;
            attach (apilogo, 0, 0, 1, 1);
            var apilabel = new Gtk.Label (_("<big>Enter your OpenWeatherMap API key</big>\n"));
            apilabel.use_markup = true;
            apilabel.halign = Gtk.Align.CENTER;
            attach (apilabel, 0, 1, 1, 1);
            var apibox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            var apientry = new Gtk.Entry ();
            apientry.width_chars = 35;
            apientry.set_text (setting.get_string ("apiid"));
            apientry.halign = Gtk.Align.END;
            var apibutton = new Gtk.Button.with_label (_("Save"));
            apibutton.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            apibutton.halign = Gtk.Align.START;
            apibox.pack_start (apientry, true, false, 0);
            apibox.pack_start (apibutton, false, false, 0);
            attach (apibox, 0, 2, 1, 1);
            var apilink = new Gtk.Label ("");
            apilink.label = _("\n\n\n<small>If you don't have it, please visit: <a href =\"https://home.openweathermap.org/users/sign_up\">OpenWeatherMap</a></small>");
            apilink.use_markup = true;
            apilink.halign = Gtk.Align.CENTER;
            attach (apilink, 0, 3, 1, 1);
            apibutton.clicked.connect (() => {
                if (apientry.get_text () != "") {
                    setting.set_string ("apiid", apientry.get_text ());
                    window.remove (window.get_child ());
                    var city = new Weather.Widgets.City (window, header);
                    window.add (city);
                    window.show_all ();
                } else {
                    var err_msg = new Granite.MessageDialog.with_image_from_icon_name (
                        _("Error"),
                        _("The API key cannot be empty"),
                        "dialog-warning",
                        Gtk.ButtonsType.CLOSE
                    );
                    err_msg.transient_for = window;
                    err_msg.run ();
                    err_msg.destroy ();
                }
            });
        }
    }
}
