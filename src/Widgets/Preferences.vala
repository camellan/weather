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

    public class Preferences : Gtk.Dialog {

        private Settings settings = new Settings ("com.github.bitseater.weather");

        public Preferences (Gtk.Window window) {
            this.border_width = 5;
            this.resizable = false;
            this.deletable = false;
            this.transient_for = window;
            this.modal = true;

            var title = new Gtk.Label ("Preferences");
            title.get_style_context ().add_class ("h4");
            title.halign = Gtk.Align.START;

            var theme_lab = new Gtk.Label ("Dark theme: ");
            theme_lab.halign = Gtk.Align.END;
            theme_lab.margin_start = 12;

            var theme = new Gtk.Switch ();
            if (settings.get_boolean ("dark")) {
                theme.active = true;
            } else {
                theme.active = false;
            }
            theme.notify["active"].connect (() => {
               if (theme.get_active ()) {
                   Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
                   settings.set_boolean ("dark", true);
               } else {
                   Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
                   settings.set_boolean ("dark", false);
               }
            });

            var layout = new Gtk.Grid ();
            layout.column_spacing = 12;
            layout.row_spacing = 6;
            layout.margin = 5;
            layout.margin_bottom = 19;
            layout.margin_top = 0;

            layout.attach (title, 0, 0, 1, 1);
            layout.attach (theme_lab, 0, 1, 1, 1);
            layout.attach (theme, 1, 1, 1, 1);

            Gtk.Box content = this.get_content_area () as Gtk.Box;
            content.add (layout);

            this.add_button ("Close", Gtk.ResponseType.CANCEL);
            this.response.connect (() => {
                this.destroy ();
            });

            this.show_all ();
        }
    }
}
