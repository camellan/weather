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
namespace Weather.Widgets {

    public class Current : Gtk.Box {

        public Current (Gtk.Window window, Weather.Widgets.Header header) {
            orientation = Gtk.Orientation.HORIZONTAL;

            var setting = new Settings ("com.github.bitseater.weather");
            header.custom_title = null;
            header.set_title (setting.get_string ("location") + ", " + setting.get_string ("state") + " " + setting.get_string ("country"));
            header.change_visible (true);

            string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
            string idplace = setting.get_string ("idplace");
            string apiid = setting.get_string ("apiid");
            string units = setting.get_string ("units");
            string uri = idplace + "&APPID=" + apiid + "&units=" + units + "&lang=" + lang;

            var today = new Weather.Widgets.Today (setting.get_string ("idplace"), window);
            var forecast = new Weather.Widgets.Forecast (uri);
            var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            pack_start (today, true, true, 0);
            pack_start (separator, false, true, 0);
            pack_start (forecast, true, true, 0);

            //Configure header nav
            header.show_mapwindow.connect (() => {
                Gtk.Widget child = window.get_child ();
                window.remove (child);
                child.destroy ();
                window.add (new Weather.Widgets.MapView (window, header));
                window.show_all ();
            });

            //Update countdown
            var interval = setting.get_int ("interval");
            GLib.Timeout.add_seconds (interval, () => {
                Gtk.Widget child = window.get_child ();
                window.remove (child);
                child.destroy ();
                var current = new Weather.Widgets.Current (window, header);
                window.add (current);
                current.show_all ();
                return false;
            }, GLib.Priority.DEFAULT);
        }
    }
}
