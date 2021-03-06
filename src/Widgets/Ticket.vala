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

    public class Ticket : Gtk.Revealer {

        private Gtk.Label label;

        public Ticket (string text) {
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.START;
            transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
            transition_duration = 500;
            var frame = new Gtk.Frame (null);
            frame.get_style_context ().add_class ("app-notification");
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            label = new Gtk.Label (text);
            var button = new Gtk.Button.from_icon_name ("window-close-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            button.get_style_context ().add_class ("ticket");
            button.receives_default = true;
            box.pack_start (label, false, true, 0);
            box.pack_end (button, false, false, 0);
            frame.add (box);
            add (frame);
            button.clicked.connect (() => {
                this.reveal_child = false;
            });
        }

        public void set_text (string? text) {
            this.label.label = text;
        }

        public void showtime (int interval) {
            GLib.Timeout.add (interval, () => {
                reveal_child = false;
                return false;
            }, GLib.Priority.DEFAULT);
        }
    }
}
