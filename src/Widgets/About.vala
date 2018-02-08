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

        public About (Weather.MainWindow window) {
            transient_for = window;
            modal = true;
            destroy_with_parent = true;

            artists = {"Carlos Suárez <bitseater@gmail.com>"};
            authors = {"Carlos Suárez <bitseater@gmail.com>"};
            comments = _("A forecast application with OpenWeatherMap API");
            copyright = "Copyright \xc2\xa9 Carlos Suárez - 2017";
            license_type = Gtk.License.GPL_3_0;
            logo_icon_name = Constants.ICON_NAME;
            program_name = Constants.APP_NAME;
            translator_credits = "(es, en, fr) Carlos Suárez <bitseater@gmail.com>
                                (ru) Andrey Kultyapov <camellan@yandex.ru>
                                (lt) welaq https://github.com/welaq";
            version = Constants.VERSION;
            website = "https://github.com/bitseater/weather";
            website_label = _("website");

            string[] colaborators = {"Paulo Galardi <lainsce@airmail.cc>", "Andrey Kultyapov <camellan@yandex.ru>", "Cassidy James Blaede https://github.com/cassidyjames", "Corentin Noël https://github.com/tintou"};
            add_credit_section (_("Colaborators"), colaborators);

            response.connect (() => {
                    destroy ();
            });
        }
    }
}
