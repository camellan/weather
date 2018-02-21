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
namespace  Weather.Utils {

    public static string to_string2 (double d) {
            char [] cadena = new char [16];
            d.format (cadena, "%-.2f");
            string texto = (string) cadena;
            return texto;
    }

    public static string to_string0 (double d) {
            char [] cadena = new char [16];
            d.format (cadena, "%-.0f");
            string texto = (string) cadena;
            return texto;
    }

    public static string get_units () {
        string lang = Gtk.get_default_language ().to_string ().substring (0, 2);
        string units = "";
        switch (lang) {
            case "C":
                units = "imperial";
                break;
            case "en_US":
                units = "imperial";
                break;
            case "my_MM":
                units = "imperial";
                break;
            case "en_GB":
                units = "british";
                break;
            default:
                units = "metric";
                break;
        }
        return units;
    }
}
