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

    private GClue.Simple simple;

    public async void get_location (Weather.MainWindow window, Weather.Widgets.Header header) {
        try {
            simple = yield new GClue.Simple ("com.github.bitseater.weather", GClue.AccuracyLevel.CITY, null);

            simple.notify["location"].connect (() => {
                on_save_coords (window, header);
            });
            on_save_coords (window, header);
        } catch (Error e) {
            warning ("Failed to connect to GeoClue2 service: %s", e.message);
            var city = new Weather.Widgets.City (window, header);
            window.change_view (city);
            window.show_all ();
            return;
        }
    }

    public void on_save_coords (Weather.MainWindow window, Weather.Widgets.Header header) {
        var setting = new Settings ("com.github.bitseater.weather");
        var uri1 = Constants.OWM_API_ADDR + "weather?lat=";
        var uri2 = "&APPID=" + setting.get_string ("apiid");
        var myloc = simple.get_location ();
        var location = new Geocode.Location (myloc.latitude, myloc.longitude);
        var reverse = new Geocode.Reverse.for_location (location);
        try {
            Geocode.Place mycity = reverse.resolve ();
            if (mycity != null) {
                string uri = uri1 + myloc.latitude.to_string () + "&lon=" + myloc.longitude.to_string () + uri2;
                setting.set_string ("idplace", update_id (uri).to_string());
                setting.set_string ("location", mycity.town);
                if (mycity.state != null) {
                    setting.set_string ("state", mycity.state);
                } else {
                    setting.set_string ("state", "");
                }
                if (mycity.country_code != null) {
                    setting.set_string ("country", mycity.country_code);
                } else {
                    setting.set_string ("country", "");
                }
            }
        } catch (Error e) {
            debug (e.message);
            var city = new Weather.Widgets.City (window, header);
            window.change_view (city);
            window.show_all ();
        }
        var current = new Weather.Widgets.Current (window, header);
        window.change_view (current);
        window.show_all ();
    }

    private static int64 update_id (string uri) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        session.send_message (message);
        int64 id = 0;
        try {
            var parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            var root = parser.get_root ().get_object ();
            id = root.get_int_member ("id");
        } catch (Error e) {
            debug (e.message);
        }
        return id;
    }
}
