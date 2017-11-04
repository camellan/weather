/*
* Copyright (c) 2016 bitseater (https://github.com/bitseater/weather)
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

    public class City : Gtk.Box {

        private Settings setting;

        struct Mycity {
            string country;
            int id;
            string name;
        }

        public City (Gtk.Window window) {
            orientation = Gtk.Orientation.VERTICAL;
            spacing = 5;

            var header = new Weather.Widgets.Header (window, false);
            window.set_titlebar (header);
            header.set_title ("");

            var search_line = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            setting = new Settings ("com.github.bitseater.weather");
            var uri1 = Constants.OWM_API_ADDR + "find?q=";
            var uri2 = "&type=like&APPID=" + setting.get_string ("apiid");

            var citylabel = new Gtk.Label ("");
            citylabel.label = "Search for new location: ";
            search_line.pack_start (citylabel, false, false, 5);
            var cityentry = new Gtk.Entry ();
            cityentry.primary_icon_name = "system-search-symbolic";
            cityentry.secondary_icon_name = "edit-clear-symbolic";
            var search_button = new Gtk.Button.with_label ("Search");
            search_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            search_line.pack_end (search_button, false, false, 3);
            search_line.pack_end (cityentry, true, true, 3);
            pack_start (search_line, false, false, 3);

            var cityview = new Gtk.TreeView ();
            cityview.expand = true;
            var citylist = new Gtk.ListStore (3, typeof (string), typeof (int), typeof(string));
            cityview.model = citylist;
            cityview.insert_column_with_attributes (-1, "Country", new Gtk.CellRendererText (), "text", 0);
            cityview.insert_column_with_attributes (-1, "OpenWM ID", new Gtk.CellRendererText (), "text", 1);
            cityview.insert_column_with_attributes (-1, "City", new Gtk.CellRendererText (), "text", 2);
            var scroll = new Gtk.ScrolledWindow (null,null);
            scroll.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scroll.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scroll.add (cityview);
            pack_start (scroll, true, true, 5);

            cityentry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    cityentry.set_text ("");
                    citylist.clear ();
                }
            });

            search_button.clicked.connect (() => {
                if (cityentry.get_text_length () < 3) {
                    var min_charac = new Gtk.Dialog ();
                    min_charac.transient_for = window;
                    min_charac.modal = true;
                    min_charac.add_button ("Close", Gtk.ResponseType.CLOSE).get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
                    var content = min_charac.get_content_area () as Gtk.Box;
                    var error = new Gtk.Label ("<b>ERROR</b>");
                    error.use_markup = true;
                    min_charac.set_titlebar (error);
                    var alert = new Gtk.Label (" At least of 3 characters are required! ");
                    content.add (alert);
                    min_charac.show_all ();
                    min_charac.response.connect ((response_id) => {
                        switch (response_id) {
                            case Gtk.ResponseType.CLOSE:
                                break;
                        }
                        min_charac.destroy ();
                    });
                    min_charac.show ();
                    citylist.clear ();
                } else {
                    string uri = "";
                    citylist.clear ();
                    uri = uri1 + cityentry.get_text () + uri2;
                    var session = new Soup.Session ();
                    var message = new Soup.Message ("GET", uri);
                    session.send_message (message);
                    try {
                        var parser = new Json.Parser ();
                        parser.load_from_data ((string) message.response_body.flatten ().data, -1);

                        var root = parser.get_root ().get_object ();
                        var city = root.get_array_member ("list");
                        if (root.get_int_member ("count") == 0) {
                            Gtk.TreeIter iter;
                            citylist.append (out iter);
                            citylist.set (iter, 2, "No hay datos");
                        } else {
                            Gtk.TreeIter iter;
                            foreach (var geonode in city.get_elements ()) {
                                var geoname = geonode.get_object ();
                                citylist.append (out iter);
                                citylist.set (iter, 0, geoname.get_object_member ("sys").get_string_member ("country"),
                                                    1, geoname.get_int_member ("id"),
                                                    2, geoname.get_string_member ("name"));
                            }
                        }
                    } catch (Error e) {
                            stderr.printf ("Encontrado un error");
                    }
                }
            });

            cityview.row_activated.connect (on_row_activated);
        }

        private static Mycity get_selection (Gtk.TreeModel model, Gtk.TreeIter iter) {
            var city = Mycity ();
            model.get (iter, 0, out city.country, 1, out city.id, 2, out city.name);
            return city;
        }

        private void on_row_activated (Gtk.TreeView cityview , Gtk.TreePath path, Gtk.TreeViewColumn column) {
            Gtk.TreeIter iter;
            if (cityview.model.get_iter (out iter, path)) {
                Mycity city = get_selection (cityview.model, iter);
                var setting = new Settings ("com.github.bitseater.weather");
                setting.set_string ("location", city.name);
                setting.set_string ("idplace", city.id.to_string());
                var window = cityview.get_toplevel () as Gtk.Window;
                window.remove (window.get_child ());
                var current = new Weather.Widgets.Current (window);
                window.add (current);
                window.show_all ();
            }
        }
    }
}
