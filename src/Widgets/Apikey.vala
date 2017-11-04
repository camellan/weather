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

        public Apikey (Gtk.Window window) {
            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;
            column_homogeneous = true;
            row_spacing = 10;
            column_spacing = 10;

            setting = new Settings ("com.github.bitseater.weather");
            var apilogo = new Gtk.Image.from_icon_name ("avatar-default", Gtk.IconSize.DIALOG);
            attach (apilogo, 1, 0, 8, 1);
            var apilabel = new Gtk.Label ("<big>Enter your OpenWeatherMap API key</big>\n");
            apilabel.use_markup = true;
            attach (apilabel, 1, 1, 8, 1);
            var apientry = new Gtk.Entry ();
            apientry.set_text (setting.get_string ("apiid"));
            attach (apientry, 2, 2, 6, 1);
            var apibutton = new Gtk.Button.with_label ("Save");
            apibutton.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            attach (apibutton, 8, 2, 1, 1);
            var apilink = new Gtk.Label ("");
            apilink.label = "\n\n\n<small>If you don't have it, please visit:   <a href =\"https://home.openweathermap.org/users/sign_up\">OpenWeatherMap</a></small>";
            apilink.use_markup = true;
            attach (apilink, 1, 3, 8, 4);
            apibutton.clicked.connect (() => {
                setting.set_string ("apiid", apientry.get_text ());
                window.remove (window.get_child ());
                var city = new Weather.Widgets.City (window);
                window.add (city);
                window.show_all ();
            });
        }
    }
}
