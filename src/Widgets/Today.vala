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
namespace  Weather.Widgets {

    public class Today : Gtk.Grid {

        public Today (string idplace, Weather.MainWindow window) {
            valign = Gtk.Align.START;
            halign = Gtk.Align.CENTER;
            row_spacing = 5;
            column_spacing = 5;
            margin = 15;

            var today = new Weather.Utils.OWM_Today (idplace);

            var title = new Gtk.Label (_("Today"));
            title.get_style_context ().add_class ("weather");
            title.halign = Gtk.Align.START;
            var coord_lb = new Gtk.Label (_("Coordinates :"));
            coord_lb.halign = Gtk.Align.END;
            var coord_c = new Gtk.Label ("[ " + today.coor_lat + " , " + today.coor_lon + " ]");
            coord_c.halign = Gtk.Align.START;
            var weather_main = new Gtk.Label (today.wdescrip);
            weather_main.halign = Gtk.Align.START;
            weather_main.get_style_context ().add_class ("resumen");
            var icon = new Weather.Utils.Iconame (today.icon, 128);
            icon.halign = Gtk.Align.END;
            icon.valign = Gtk.Align.START;
            var temp = new Gtk.Label (today.temp);
            temp.get_style_context ().add_class ("temp");
            temp.halign = Gtk.Align.START;
            var pres = new Gtk.Label (today.pressure);
            pres.halign = Gtk.Align.START;
            var pres_lb = new Gtk.Label (_("Pressure :"));
            pres_lb.halign = Gtk.Align.END;
            var humid = new Gtk.Label (today.humidity);
            humid.halign = Gtk.Align.START;
            var humid_lb = new Gtk.Label (_("Humidity :"));
            humid_lb.halign = Gtk.Align.END;
            var speed = new Gtk.Label (today.windspeed);
            speed.halign = Gtk.Align.START;
            var speed_lb = new Gtk.Label (_("Wind speed :"));
            speed_lb.halign = Gtk.Align.END;
            var degrees = new Gtk.Label (today.winddir);
            degrees.halign = Gtk.Align.START;
            var degrees_lb = new Gtk.Label (_("Wind dir :"));
            degrees_lb.halign = Gtk.Align.END;
            var clouds_all = new Gtk.Label (today.clouds);
            clouds_all.halign = Gtk.Align.START;
            var clouds_lb = new Gtk.Label (_("Cloudiness :"));
            clouds_lb.halign = Gtk.Align.END;
            var sun_r = new Gtk.Label (_("Sunrise :"));
            sun_r.halign = Gtk.Align.END;
            var sunrise = new Gtk.Label (today.sunrise);
            sunrise.halign = Gtk.Align.START;
            var sun_s = new Gtk.Label (_("Sunset :"));
            sun_s.halign = Gtk.Align.END;
            var sunset = new Gtk.Label (today.sunset);
            sunset.halign = Gtk.Align.START;

            attach (title, 0, 0, 2, 1);
            attach (weather_main, 0, 1, 2, 1);
            attach (temp, 0, 2, 2, 1);
            attach (icon, 3, 0, 3, 3);
            attach (new Gtk.Label (" "), 1, 3, 2, 1);
            attach (pres_lb, 1, 4, 2, 1);
            attach (pres, 3, 4, 2, 1);
            attach (humid_lb, 1, 5, 2, 1);
            attach (humid, 3, 5, 2, 1);
            attach (speed_lb, 1, 6, 2, 1);
            attach (speed, 3, 6, 2, 1);
            attach (degrees_lb, 1, 7, 2, 1);
            attach (degrees, 3, 7, 2, 1);
            attach (clouds_lb, 1, 8, 2, 1);
            attach (clouds_all, 3, 8, 2, 1);
            attach (coord_lb, 1, 9, 2, 1);
            attach (coord_c, 3, 9, 2, 1);
            attach (sun_r, 1, 10, 2, 1);
            attach (sunrise, 3, 10, 2, 1);
            attach (sun_s, 1, 11, 2, 1);
            attach (sunset, 3, 11, 2, 1);
            (window as Weather.MainWindow).set_icolabel (icon.get_icon (today.icon) + "-symbolic", today.temp);
        }
    }
}
