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

    public class MapLayer : Gtk.Box {

        public MapLayer (string url) {
            var map_view = new WebKit.WebView ();
            map_view.halign = Gtk.Align.FILL;
            map_view.valign = Gtk.Align.FILL;
            map_view.load_uri (url);
            pack_start (map_view, true, true, 0);
        }
    }
}
