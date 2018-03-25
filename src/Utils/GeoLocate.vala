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
namespace  Weather.Utils {

    struct Coord {
        double lat;
        double lon;
    }

    public void geolocate () {
        var setting = new Settings ("com.github.bitseater.weather");
        var uri1 = Constants.OWM_API_ADDR + "weather?lat=";
        var uri2 = "&APPID=" + setting.get_string ("apiid");

        Coord mycoords = get_location ();
        var location = new Geocode.Location (mycoords.lat, mycoords.lon);
        var reverse = new Geocode.Reverse.for_location (location);

        try {
            Geocode.Place mycity = reverse.resolve ();
            if (mycity != null) {
                string uri = uri1 + mycoords.lat.to_string () + "&lon=" + mycoords.lon.to_string () + uri2;
                setting.set_string ("idplace", update_id (uri).to_string());
                setting.set_string ("location", mycity.town);
                setting.set_string ("state", mycity.state);
                setting.set_string ("country", mycity.country_code);
            }
        } catch (Error e) {
            debug (e.message);
        }
    }

    private static Coord get_location () {
        var coord = Coord ();
        string uri = "https://location.services.mozilla.com/v1/geolocate?key=test";
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        session.send_message (message);

        try {
            var parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);

            var root = parser.get_root ().get_object ();

            foreach (string name in root.get_members ()) {
                if (name == "location") {
                    var mycoords = root.get_object_member ("location");
                    coord.lat = mycoords.get_double_member ("lat");
                    coord.lon = mycoords.get_double_member ("lng");
                    break;
                } else {
                    stdout.printf (_("Found an error"));
                }
            }
        } catch (Error e) {
            debug (e.message);
        }
        return coord;
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
