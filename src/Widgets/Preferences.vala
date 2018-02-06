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

    public class Preferences : Gtk.Dialog {

        public Preferences (Gtk.Window window, Weather.Widgets.Header header) {
            this.resizable = false;
            this.deletable = true;
            this.transient_for = window;
            this.modal = true;

            var setting = new Settings ("com.github.bitseater.weather");

            //Define sections
            var tit1_pref = new Gtk.Label (_("Interface"));
            tit1_pref.get_style_context ().add_class ("preferences");
            tit1_pref.halign = Gtk.Align.START;
            var tit2_pref = new Gtk.Label (_("General"));
            tit2_pref.get_style_context ().add_class ("preferences");
            tit2_pref.halign = Gtk.Align.START;

            //Change to dark theme
            var theme_lab = new Gtk.Label (_("Dark theme:"));
            theme_lab.halign = Gtk.Align.END;
            var theme = new Gtk.Switch ();
            theme.halign = Gtk.Align.START;
            if (setting.get_boolean ("dark")) {
                theme.active = true;
            } else {
                theme.active = false;
            }
            theme.notify["active"].connect (() => {
               if (theme.get_active ()) {
                   Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
                   setting.set_boolean ("dark", true);
               } else {
                   Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", false);
                   setting.set_boolean ("dark", false);
               }
            });

            //Select type of icons:symbolic or realistic
            var icon_label = new Gtk.Label (_("Symbolic icons:"));
            icon_label.halign = Gtk.Align.END;
            var icon = new Gtk.Switch ();
            icon.halign = Gtk.Align.START;
            if (setting.get_boolean ("symbolic")) {
                icon.active = true;
            } else {
                icon.active = false;
            }
            icon.notify["active"].connect (() => {
                if (icon.get_active ()) {
                    setting.set_boolean ("symbolic", true);
                } else {
                    setting.set_boolean ("symbolic", false);
                }
            });

            //Select indicator
            var ind_label = new Gtk.Label (_("Use System Tray Indicator:"));
            ind_label.halign = Gtk.Align.END;
            var ind = new Gtk.Switch ();
            ind.halign = Gtk.Align.START;
            if (setting.get_boolean ("indicator")) {
                ind.active = true;
            } else {
                ind.active = false;
            }
            ind.notify["active"].connect (() => {
                if (ind.get_active ()) {
                    setting.set_boolean ("indicator", true);
                    (window as Weather.MainWindow).create_indicator ();
                } else {
                    setting.set_boolean ("indicator", false);
                    (window as Weather.MainWindow).hide_indicator ();
                }
            });

            //Update interval
            var update_lab = new Gtk.Label (_("Update conditions every :"));
            update_lab.halign = Gtk.Align.END;
            var update_box = new Gtk.ComboBoxText ();
            update_box.append_text (_("2 hrs."));
            update_box.append_text (_("6 hrs."));
            update_box.append_text (_("12 hrs."));
            update_box.append_text (_("24 hrs."));
            int interval = setting.get_int ("interval");
            switch (interval) {
                case 7200:
                    update_box.active = 0;
                    break;
                case 21600:
                    update_box.active = 1;
                    break;
                case 43200:
                    update_box.active = 2;
                    break;
                case 86400:
                    update_box.active = 3;
                    break;
                default:
                    update_box.active = 0;
                    break;
            }

            update_box.changed.connect (() => {
                switch (update_box.active) {
                    case 0:
                        interval = 7200;
                        break;
                    case 1:
                        interval = 21600;
                        break;
                    case 2:
                        interval = 43200;
                        break;
                    case 3:
                        interval = 86400;
                        break;
                    default:
                        interval = 7200;
                        break;
                }
                setting.set_int ("interval", interval);
            });

            //System units
            var unit_lab = new Gtk.Label (_("Units:"));
            unit_lab.halign = Gtk.Align.END;
            var unit_box = new Gtk.ComboBoxText ();
            unit_box.append_text (_("Metric System"));
            unit_box.append_text (_("Imperial System"));
            if (setting.get_string ("units") != "metric") {
                unit_box.active = 1;
            } else {
                unit_box.active = 0;
            }

            unit_box.changed.connect (() => {
                if (unit_box.active == 0) {
                    setting.set_string ("units", "metric");
                } else {
                    setting.set_string ("units", "imperial");
                }
            });

            //Restore API
            var api_lab = new Gtk.Label (_("Restore API key:"));
            api_lab.halign = Gtk.Align.END;
            var api_entry = new Gtk.Entry ();
            api_entry.halign = Gtk.Align.START;
            api_entry.width_chars = 30;
            api_entry.editable = false;
            api_entry.text = setting.get_string ("apiid");
            api_entry.secondary_icon_name = "edit-clear";
            api_entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    api_entry.set_text ("");
                    setting.set_string ("apiid", "");
                }
            });

            //Automatic location
            var loc_label = new Gtk.Label (_("Find my location automatically:"));
            loc_label.halign = Gtk.Align.END;
            var loc = new Gtk.Switch ();
            loc.halign = Gtk.Align.START;
            if (setting.get_boolean ("auto")) {
                loc.active = true;
            } else {
                loc.active = false;
            }
            loc.notify["active"].connect (() => {
                if (loc.get_active ()) {
                    setting.set_boolean ("auto", true);
                } else {
                    setting.set_boolean ("auto", false);
                }
            });

            //Create UI
            var layout = new Gtk.Grid ();
            layout.valign = Gtk.Align.START;
            layout.column_spacing = 12;
            layout.row_spacing = 12;
            layout.margin = 12;
            layout.margin_top = 0;

            layout.attach (tit1_pref, 0, 0, 2, 1);
            layout.attach (theme_lab, 2, 1, 1, 1);
            layout.attach (theme, 3, 1, 1, 1);
            layout.attach (icon_label, 2, 2, 1, 1);
            layout.attach (icon, 3, 2, 1, 1);
            layout.attach (ind_label, 2, 3, 1, 1);
            layout.attach (ind, 3, 3, 1, 1);
            layout.attach (tit2_pref, 0, 4, 2, 1);
            layout.attach (unit_lab, 2, 5, 1, 1);
            layout.attach (unit_box, 3, 5, 2, 1);
            layout.attach (update_lab, 2, 6, 1, 1);
            layout.attach (update_box, 3, 6, 2, 1);
            layout.attach (api_lab, 2, 7, 1, 1);
            layout.attach (api_entry, 3, 7, 1, 1);
            layout.attach (loc_label, 2, 8, 1, 1);
            layout.attach (loc, 3, 8, 1, 1);

            Gtk.Box content = this.get_content_area () as Gtk.Box;
            content.valign = Gtk.Align.START;
            content.border_width = 6;
            content.add (layout);

            //Actions
            this.add_button (_("Close"), Gtk.ResponseType.CANCEL);
            this.response.connect (() => {
                this.destroy ();
                Gtk.Widget child = window.get_child ();
                window.remove (child);
                child.destroy ();
                if (setting.get_string ("apiid") == "") {
                    var apikey = new Weather.Widgets.Apikey (window, header);
                    window.add (apikey);
                } else if (setting.get_boolean ("auto")) {
                    Weather.Utils.geolocate ();
                    var current = new Weather.Widgets.Current (this, header);
                    window.add (current);
                } else if (setting.get_string ("idplace") == "") {
                    var city = new Weather.Widgets.City (window, header);
                    window.add (city);
                } else {
                    var current = new Weather.Widgets.Current (window, header);
                    window.add (current);
                }
                window.show_all ();
            });

            this.show_all ();
        }
    }
}
