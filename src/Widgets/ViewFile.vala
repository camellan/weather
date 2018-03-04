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
namespace Weather.Widgets {

    public class ViewFile : Gtk.Dialog {

        public ViewFile (Weather.MainWindow window) {
            resizable = false;
            set_size_request (750, 590);
            deletable = true;
            transient_for = window;
            modal = true;

            var filelabel = new Gtk.Label (_("Current Weather Data"));
            filelabel.get_style_context ().add_class ("preferences");
            filelabel.halign = Gtk.Align.START;

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scrolled.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scrolled.set_size_request(650, 450);
            var file_view = new Gtk.TextView ();
            file_view.editable = false;
            file_view.halign = Gtk.Align.FILL;
            file_view.valign = Gtk.Align.FILL;
            file_view.set_wrap_mode (Gtk.WrapMode.WORD);
            string text;
            try {
                var file = File.new_for_path (Environment.get_user_cache_dir () + "/" + Constants.EXEC_NAME + "/current.json");
                if (file.query_exists ()) {
                    FileUtils.get_contents (file.get_path (), out text);
                    file_view.buffer.text = text;
                } else {
                    file_view.buffer.text = _("Data file not found");
                }
            } catch (Error e) {
                debug (e.message);
            }
            scrolled.add (file_view);

            Gtk.Box content = this.get_content_area () as Gtk.Box;
            content.valign = Gtk.Align.START;
            content.margin = 12;
            content.pack_start (filelabel, false, false, 3);
            content.pack_start (scrolled, true, true, 3);

            //Add buttons
            add_button (_("Close"), Gtk.ResponseType.CANCEL);
            response.connect (() => {
                destroy ();
            });
            show_all ();
        }
    }
}
