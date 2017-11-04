/*
* Copyright (c) 2016 bitseater (https://github.com/bitseater/weather)
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
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA 02111-1307, USA.
*
* Authored by: bitseater <bitseater@gmail.com>
*/
namespace Weather {

    public class WeatherApp : Granite.Application {

        public MainWindow window;

        construct {
            program_name = "Weather";
            exec_name = "Weather";

            build_data_dir = Constants.DATADIR;
            build_pkg_data_dir = Constants.PKGDATADIR;
            build_release_name = Constants.RELEASE_NAME;
            build_version = Constants.VERSION;
            build_version_info = Constants.VERSION_INFO;

            app_years = "2016";
            app_icon = "weather-clear";
            app_launcher = "Weather.desktop";
            application_id = "com.github.bitseater.weather";

            main_url = "https://github.com/bitseater/weather";
            bug_url = "https://github.com/bitseater/weather";
            help_url = "https://github.com/bitseater/weather";
            translate_url = "https://github.com/bitseater/weather";

            about_authors = { "bitseater <bitseater@gmail.com>" };
            about_documenters = { "bitseater <bitseater@gmail.com>" };
            about_artists = { "bitseater <bitseater@gmail.com>" };
            about_comments = "A forecast application for elementary OS";
            about_translators = "bitseater <bitseater@gmail.com>";
            about_license_type = Gtk.License.GPL_3_0;
        }

        public WeatherApp () {
//          // Traducción
//          Intl.setlocale (LocaleCategory.ALL, "");
//          string langpack_dir = Path.build_filename (Constants.INSTALL_PREFIX, "share", "locale");
//          Intl.bindtextdomain (Constants.GETTEXT_PACKAGE, langpack_dir);
//          Intl.bind_textdomain_codeset (Constants.GETTEXT_PACKAGE, "UTF-8");
//          Intl.textdomain (Constants.GETTEXT_PACKAGE);

            // Debug service
            Granite.Services.Logger.initialize ("Weather");
            Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;
        }

        public override void activate () {
            if (get_windows () == null) {
                window = new MainWindow (this);
                window.show_all ();
            } else {
                window.present ();
            }
        }

        public static void main (string [] args) {
            var app = new Weather.WeatherApp ();
            app.run (args);
        }
    }
}
