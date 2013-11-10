/* Tablet Launcher
 * A simple app launcher, oriented to tablet devices
 *
 * (C)2013 Raster Software Vigo (Sergio Costas)
 *
 * This code is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>. */

using GLib;
using Gtk;
using Gee;

// project version=0.8.0

int main(string[] argv) {

	Intl.bindtextdomain(Constants.GETTEXT_PACKAGE, GLib.Path.build_filename(Constants.DATADIR,"locale"));
	//Intl.setlocale (LocaleCategory.ALL, "");
	Intl.textdomain("tabletlauncher");
	Intl.bind_textdomain_codeset("tabletlauncher", "UTF-8" );

	Gtk.init(ref argv);

	var dk=new launcher_ui();
	
	Gtk.main();
	
	return 0;
}
