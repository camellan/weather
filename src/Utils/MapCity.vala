/*
* Copyright (c) 2017 bitseater (https://github.com/bitseater/weather)
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
namespace Weather.Utils {

    public class MapCity : Gtk.Window {

        private Champlain.View view;
        private Clutter.Stage stage;

        public MapCity (double lat, double lon) {
            set_default_size (450, 450);
            title = "";
            var embed = new GtkClutter.Embed();
            stage = (Clutter.Stage) embed.get_stage();
            stage.set_size (450, 450);
            //Map view
            view = new Champlain.View ();
            view.set_size (450, 450);
            stage.add_child (view);
            //Layer
            var pointer = new Champlain.MarkerLayer ();
            var marker = new Champlain.Point ();
            marker.set_location (lat, lon);
            pointer.add_marker (marker);
            view.add_layer (pointer);
            view.reactive = true;
            view.zoom_level = 5;
            view.kinetic_mode = true;
            view.center_on (lat, lon);
            add (embed);
        }
    }
}
