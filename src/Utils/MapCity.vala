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
namespace Weather.Utils {

    public class MapCity : Gtk.Popover {

        private Champlain.View view;
        private Clutter.Stage stage;

        public MapCity (double lat, double lon, Gtk.Widget relative) {
            relative_to = relative;
            modal = true;
            position = Gtk.PositionType.TOP;
            var popbox = new Gtk.ScrolledWindow (null, null);
            popbox.width_request = 200;
            popbox.height_request = 200;
            var embed = new GtkClutter.Embed();
            stage = (Clutter.Stage) embed.get_stage();
            stage.set_size (200, 200);
            //Map view
            view = new Champlain.View ();
            view.set_size (200, 200);
            stage.add_child (view);
            //Layer
            var pointer = new Champlain.MarkerLayer ();
            var marker = new Champlain.Marker ();
            try {
                var poi = Gtk.IconTheme.get_default ().load_icon ("mark-location-symbolic", 24, Gtk.IconLookupFlags.FORCE_SIZE);
                var img = new Clutter.Image ();
                img.set_data (poi.get_pixels (), Cogl.PixelFormat.RGBA_8888, poi.width, poi.height, poi.rowstride);
                marker.content = img;
                marker.set_size (poi.width, poi.height);
                marker.translation_x = -poi.width/2;
                marker.translation_y = -poi.height;
            } catch (Error e) {
                debug (e.message);
            }
            marker.set_location (lat, lon);
            pointer.add_marker (marker);
            view.add_layer (pointer);
            view.reactive = true;
            view.zoom_level = 5;
            view.kinetic_mode = true;
            view.center_on (lat, lon);
            popbox.add (embed);
            add (popbox);
        }
    }
}
