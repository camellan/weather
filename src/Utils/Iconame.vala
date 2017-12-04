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

    public class Iconame : Gtk.Image {

        public Iconame (string iconum, int size) {
            icon_size = Gtk.IconSize.DIALOG;
            icon_name = get_icon (iconum);
            pixel_size = size;
        }

        private string get_icon (string code) {
            string str_icon = "";
            switch (code) {
                case "01d":
                    str_icon = "weather-clear-symbolic";
                    break;
                case "01n":
                    str_icon = "weather-clear-night-symbolic";
                    break;
                case "02d":
                    str_icon = "weather-few-clouds-symbolic";
                    break;
                case "02n":
                    str_icon = "weather-few-clouds-night-symbolic";
                    break;
                case "03d":
                    str_icon = "weather-few-clouds-symbolic";
                    break;
                case "03n":
                    str_icon = "weather-few-clouds-night-symbolic";
                    break;
                case "04d":
                    str_icon = "weather-overcast-symbolic";
                    break;
                case "04n":
                    str_icon = "weather-overcast-symbolic";
                    break;
                case "09d":
                    str_icon = "weather-showers-scattered-symbolic";
                    break;
                case "09n":
                    str_icon = "weather-showers-scattered-symbolic";
                    break;
                case "10d":
                    str_icon = "weather-showers-symbolic";
                    break;
                case "10n":
                    str_icon = "weather-showers-symbolic";
                    break;
                case "11d":
                    str_icon = "weather-storm-symbolic";
                    break;
                case "11n":
                    str_icon = "weather-storm-symbolic";
                    break;
                case "13d":
                    str_icon = "weather-snow-symbolic";
                    break;
                case "13n":
                    str_icon = "weather-snow-symbolic";
                    break;
                case "50d":
                    str_icon = "weather-fog-symbolic";
                    break;
                case "50n":
                    str_icon = "weather-fog-symbolic";
                    break;
                default :
                    str_icon = "dialog-error-symbolic";
                    break;
            }
            return str_icon;
        }
    }
}
