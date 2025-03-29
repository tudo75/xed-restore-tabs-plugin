/*
 * restore-tabs.vala
 *
 * Copyright 2022 Nicola Tudino
 *
 * This file is part of xed-restore-tabs-plugin.
 *
 * xed-restore-tabs-plugin is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * xed-restore-tabs-plugin is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with xed-restore-tabs-plugin.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

namespace RestoreTabsPlugin {

    /*
    * Register plugin extension types
    */
    [CCode (cname="G_MODULE_EXPORT peas_register_types")]
    [ModuleInit]
    public void peas_register_types (TypeModule module) 
    {
        var objmodule = module as Peas.ObjectModule;

        // Register my plugin extension
        objmodule.register_extension_type (typeof (Xed.AppActivatable), typeof (RestoreTabsPlugin.RestoreTabsApp));
        objmodule.register_extension_type (typeof (Xed.WindowActivatable), typeof (RestoreTabsPlugin.RestoreTabsWindow));
        // Register my config dialog
        objmodule.register_extension_type (typeof (PeasGtk.Configurable), typeof (RestoreTabsPlugin.ConfigRestoreTabs));
    }

    /*
    * AppActivatable
    */
    public class RestoreTabsApp : Xed.AppActivatable, Peas.ExtensionBase
    {


        public RestoreTabsApp () {
            GLib.Object ();
        }

        public Xed.App app {
            owned get; construct;
        }

        public void activate () {
            // print ("RestoreTabsApp activated\n");

        }

        public void deactivate () {
            // print ("RestoreTabsApp deactivated\n");
        }
    }

    /*
    * WindowActivatable
    */
    public class RestoreTabsWindow : Xed.WindowActivatable, Peas.ExtensionBase
    {
        
        private static bool TABS_LOADED = false;
        private GLib.Settings settings = new GLib.Settings ("com.github.tudo75.xed-restore-tabs-plugin");
        private uint n_tabs = 0;
        private ulong tab_close_handler_id;

        public RestoreTabsWindow () {
            GLib.Object ();
        }

        public Xed.Window window {
            owned get; construct;
        }

        public void activate () {
            // print ("RestoreTabsWindow activated\n");

            // Connect to the delete_event signal. on close window
            window.delete_event.connect(this.on_window_delete_event);
            
            // Connect to the show signal. on load window
            window.show.connect(this.on_window_show);
        }

        public void deactivate () {
            // print ("RestoreTabsWindow deactivated\n");
        }

        public void update_state () {
            // print ("RestoreTabsWindow update_state\n");
        }

        public bool on_window_delete_event(Gtk.Widget widget, Gdk.EventAny event) {
            if (this.settings.get_boolean ("enable-restore-tabs")) {
                if (window == widget) {
                    string[] uris = {};
                    foreach (var doc in window.get_documents ()) {
                        if (doc.get_file().get_location() != null) {
                            uris += doc.get_file().get_location().get_uri();
                        }
                    }
                    // save an empty array if all tabs were closed, otherway an array with all the current open tabs
                    GLib.Variant urisVariant = new GLib.Variant.strv(uris);
                    settings.set_value("uris", urisVariant);
                }
            }
            return false; // false to propagate the delete_event as usually
        }

        public void on_window_show(Gtk.Widget widget) 
        {
            if (this.settings.get_boolean ("enable-restore-tabs")) {
                if (window == widget) {
                    // Only restore tabs for the first window instance.
                    if (!TABS_LOADED) {
                        GLib.Settings file_browser_settings = new GLib.Settings ("org.x.editor.plugins.filebrowser");
                        file_browser_settings.set_boolean("open-at-first-doc", false);
                        GLib.Variant urisVariant = settings.get_value("uris");
                        VariantIter iter = urisVariant.iterator ();
                        string val = null;
                        while (iter.next("s", out val)) {
                            GLib.File location = GLib.File.new_for_uri(val);
                            if (location != null) {
                                window.create_tab_from_location(location, null, 0, false, true);
                                n_tabs++;
                            }
                        }
                        TABS_LOADED = true;
                        file_browser_settings.set_boolean("open-at-first-doc", true);
                    }
                }
            }
            if (TABS_LOADED)
            {
                // handler to catch the Untitled Document tab
                tab_close_handler_id = window.tab_added.connect (this.on_tab_added);
            }
        }

        public void on_tab_added (Xed.Window window, Xed.Tab tab) {
            // print ("Tab added\n");
            Xed.Document document = tab.get_document ();

            if (document.get_file ().get_location () == null && window.get_documents ().length () > n_tabs) {
                window.close_tab (tab);
                window.disconnect (tab_close_handler_id);
            } 
        }
    }

    /*
    * Plugin config dialog
    */
    public class ConfigRestoreTabs : Peas.ExtensionBase, PeasGtk.Configurable {

        private GLib.Settings settings = new GLib.Settings ("com.github.tudo75.xed-restore-tabs-plugin");

        public ConfigRestoreTabs () {
            GLib.Object ();
        }

        public Gtk.Widget create_configure_widget () {

            var label = new Gtk.Label ("");
            label.set_markup (_("<big>Xed RestoreTabs Plugin Settings</big>"));
            label.set_margin_top (10);
            label.set_margin_bottom (15);
            label.set_margin_start (10);
            label.set_margin_end (10);

            int grid_row = 0;

            Gtk.Grid main_grid = new Gtk.Grid ();
            main_grid.set_valign (Gtk.Align.START);
            main_grid.set_margin_top (10);
            main_grid.set_margin_bottom (10);
            main_grid.set_margin_start (10);
            main_grid.set_margin_end (10);
            main_grid.set_column_homogeneous (false);
            main_grid.set_row_homogeneous (false);
            main_grid.set_vexpand (true);
            main_grid.attach (label, 0, grid_row, 1, 1);
            grid_row++;

            Gtk.CheckButton enable_restore_tabs = new Gtk.CheckButton.with_label (_("Enable Restore Tabs"));
            this.settings.bind ("enable-restore-tabs", enable_restore_tabs, "active", GLib.SettingsBindFlags.DEFAULT | GLib.SettingsBindFlags.GET_NO_CHANGES);
            main_grid.attach (enable_restore_tabs, 0, grid_row, 1, 1);

            return main_grid;
        }
    }
}