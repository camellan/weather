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

        public Current (Weather.MainWindow window, Weather.Widgets.Header header) {
            orientation = Gtk.Orientation.HORIZONTAL;

            var setting = new Settings ("com.github.bitseater.weather");
            header.custom_title = null;
            header.set_title (setting.get_string ("location") + ", " + setting.get_string ("state") + " " + setting.get_string ("country"));
            header.change_visible (true);
            string idplace = setting.get_string ("idplace");
            var today = new Weather.Widgets.Today (idplace, window);
            var forecast = new Weather.Widgets.Forecast (idplace);
            var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            pack_start (today, true, true, 0);
            pack_start (separator, false, true, 0);
            pack_start (forecast, true, true, 0);

            //Configure header nav
            header.show_mapwindow.connect (() => {
                (window.get_child ()).destroy ();
                window.add (new Weather.Widgets.MapView (window, header));
                window.show_all ();
            });
            if (setting.get_string ("apiid") != Constants.API_KEY) {
                header.upd_button.sensitive = true;
            }

            //Update countdown
            var interval = setting.get_int ("interval");
            GLib.Timeout.add_seconds (interval, () => {
                (window.get_child ()).destroy ();
                var current = new Weather.Widgets.Current (window, header);
                window.add (current);
                //window.show_all ();
                return false;
            }, GLib.Priority.DEFAULT);
        }
    }
}
