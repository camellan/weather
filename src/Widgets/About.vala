/*
* Copyright (c) 2017 bitseater ()
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

    public class About : Gtk.AboutDialog {

        public About (Gtk.Window window) {
            transient_for = window;
            modal = true;
            destroy_with_parent = true;
            artists = {"Carlos Suárez <bitseater@gmail.com>"};
            authors = {"Carlos Suárez <bitseater@gmail.com>"};
            comments = _("A forecast application with OpenWeatherMap API");
            copyright = _("Developed using Vala, Gtk & Granite - bitseater - 2017");
            license_type = Gtk.License.GPL_3_0;
            logo_icon_name = "weather-clear-symbolic";
            program_name = "Weather";
            translator_credits = "Carlos Suárez <bitseater@gmail.com>";
            version = Constants.VERSION;
            website = "https://github.com/bitseater/weather";
            website_label = _("website");

            response.connect (() => {
                    destroy ();
            });
        }
    }
}
