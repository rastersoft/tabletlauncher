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

class launcher_ui:Gtk.Window {

	private Gtk.ListStore model;
	private Gtk.TreeIter iter;
	private Gtk.IconView view;
	private desktop_entries app_list;
	private Gtk.Box box;
	Gtk.Button[] button_categories;
	string categories;
	
	public launcher_ui() {
	
		this.destroy.connect(() => {
			Gtk.main_quit();
		});
		this.title="tabletwm_launcher";

		categories="";

		app_list = new desktop_entries();

		var main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		button_categories = {};
		Gtk.Button nbutton;
		
		nbutton=new Gtk.Button.with_label (_("All"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("");
		});
		nbutton=new Gtk.Button.with_label (_("Multimedia"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("AudioVideo");
		});
		nbutton=new Gtk.Button.with_label (_("Development"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Development");
		});
		nbutton=new Gtk.Button.with_label (_("Education"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Education");
		});
		nbutton=new Gtk.Button.with_label (_("Games"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Game");
		});
		nbutton=new Gtk.Button.with_label (_("Graphics"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Graphics");
		});
		nbutton=new Gtk.Button.with_label (_("Internet"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Network");
		});
		nbutton=new Gtk.Button.with_label (_("Office"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Office");
		});
		nbutton=new Gtk.Button.with_label (_("Settings"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Settings");
		});
		nbutton=new Gtk.Button.with_label (_("System"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("System");
		});
		nbutton=new Gtk.Button.with_label (_("Utility"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Utility");
		});
		nbutton=new Gtk.Button.with_label (_("Others"));
		button_categories+=nbutton;
		nbutton.clicked.connect(() => {
			this.filter_apps("Other");
		});

		// The ButtonBox:
		var buttonbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		
		foreach (Gtk.Button* button in button_categories) {
			buttonbox.pack_start(button,true,true);
		}
		main_box.pack_start(buttonbox,false,true);
		this.add(main_box);
		
		var icon_container=new Gtk.ScrolledWindow(null,null);
		icon_container.hscrollbar_policy=PolicyType.NEVER;
		icon_container.vscrollbar_policy=PolicyType.AUTOMATIC;
		main_box.pack_start(icon_container,true,true);

	 	model = new Gtk.ListStore (3, typeof (Gdk.Pixbuf), typeof (string), typeof (GLib.DesktopAppInfo));
		view = new Gtk.IconView.with_model(model);
		view.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		view.item_activated.connect(this.on_click);
		view.activate_on_single_click=true;
		view.selection_mode=SelectionMode.SINGLE;
		view.columns=-1;
		view.set_pixbuf_column (0);
		view.set_text_column (1);
		icon_container.add(view);

		this.show_all();

		this.refresh_ui();
		
	}
	
	public bool unselect() {
	
		this.view.unselect_all();
		return false;
	}
	
	public void on_click(Gtk.TreePath path) {
	
		var iter = Gtk.TreeIter();
		Value val;
		GLib.DesktopAppInfo *info;
		
		model.get_iter(out iter,path);
		model.get_value(iter,2,out val);
		info=val.get_object();
		info->launch(null,null);
		GLib.Timeout.add(2000,this.unselect);
	}
	
	public void refresh_ui() {
	
		this.app_list.refresh_entries();
		this.model.clear();
		view.margin=10;
		view.item_width=96;
		view.item_padding=10;
		view.spacing=2;

		var theme = Gtk.IconTheme.get_default();

		var entries=this.app_list.get_entries(this.categories);
		Gdk.Pixbuf pbuf=null;
		TreeIter iter;
		foreach(var element in entries) {
			this.model.append (out iter);
			if (element.entry_icon!=null) {
				try {
					var tmp1=theme.lookup_by_gicon(element.entry_icon,48,0);
					pbuf = tmp1.load_icon();
				} catch {
					pbuf=null;
				}
			} else {
				pbuf=null;
			}
			if (pbuf==null) {
				pbuf = this.view.render_icon(Stock.FILE,IconSize.DIALOG,"");
			}
			this.model.set (iter,0,pbuf);
			this.model.set (iter,1,element.entry_name);
			this.model.set (iter,2,element.info);
		}
	}
	
	public void filter_apps(string category) {
	
		this.categories=category;
		this.refresh_ui();
	
	}
	
}
