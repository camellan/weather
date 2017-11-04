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

            set_destroy_with_parent (true);
            set_transient_for (window);
            set_modal (true);

            artists = {"bitseater <bitseater@gmail.com>"};
            authors = {"bitseater <bitseater@gmail.com>"};
            comments = "A forecast application for elementary OS";
            copyright = "Developed using Vala, Gtk & Granite - 2017";
            license_type = Gtk.License.GPL_3_0;
            logo_icon_name = "weather-clear";
            program_name = "Weather";
            translator_credits = "bitseater <bitseater@gmail.com>";
            version = Constants.VERSION;
            website = "https://github.com/bitseater/weather";
            website_label = "website";

            response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
                    hide_on_delete ();
                }
            });
        }
    }
}
