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
namespace Weather.Utils {

    public class MiniMap : Gtk.Box {

        private Champlain.View view;
        private Clutter.Stage stage;

        public MiniMap (double lat, double lon) {
            var popbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            popbox.width_request = 50;
            popbox.height_request = 50;
            var embed = new GtkClutter.Embed();
            stage = (Clutter.Stage) embed.get_stage();
            stage.set_size (50, 50);
            //Map view
            view = new Champlain.View ();
            view.set_size (50, 50);
            stage.add_child (view);
            view.reactive = false;
            view.zoom_level = 1;
            view.kinetic_mode = false;
            view.center_on (lat, lon);
            popbox.add (embed);
            add (popbox);
            show_all ();
        }
    }
}
