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
using Gee;
//needed for autovala
//using GIO-unix;

public class desktop_entry:GLib.Object {

	public string entry_name;
	public GLib.Icon entry_icon;

	private string[]? entry_group;
	public GLib.DesktopAppInfo info;
	
	public desktop_entry(string file) {
	
		this.entry_group=null;
		info=new DesktopAppInfo.from_filename(file);
	
		if ((info!=null)&&(info.get_is_hidden()==false)&&(info.get_nodisplay()==false)) {
			this.entry_name=info.get_display_name();
			this.entry_icon=info.get_icon();

			var categories=info.get_categories();
			if (categories!=null) {
				bool audiovideo=false;
				bool found=false;
				this.entry_group={};
				var group_list=categories.split(";");
				foreach(var element in group_list) {
					if (element!="") {
					
						if ((element=="AudioVideo")||
							(element=="Audio")||
							(element=="Video")) {
							
							if(audiovideo==false) {
								audiovideo=true;
								this.entry_group+="AudioVideo"; // only add AudioVideo
								found=true;
							}
						} else if ((element=="Development")||
							(element=="Education")||
							(element=="Game")||
							(element=="Graphics")||
							(element=="Network")||
							(element=="Office")||
							(element=="Settings")||
							(element=="System")||
							(element=="Utility")) {
								this.entry_group+=element;
								found=true;
						}
					}
				}
				if(found==false) {
					this.entry_group+="Other";
				}
			}
		}
	}

	public bool is_in_group(string group) {
		foreach(var element in this.entry_group) {
			if(group==element) {
				return true;
			}
		}
		return false;
	}
	
	public string[] get_groups() {
	
		return this.entry_group;
	
	}
}

class desktop_entries:GLib.Object {

	private Gee.List<desktop_entry> entries;

	public desktop_entries() {
		this.refresh_entries();
	}

	public void refresh_entries() {
	
		this.entries=new Gee.ArrayList<desktop_entry>();
		var lpaths=GLib.Environment.get_variable("XDG_DATA_DIRS");
		string[] paths;
		if (lpaths==null) {
			paths={};
		} else {
			paths=lpaths.split(":");
		}
		paths+="/usr/share";
		paths+="/usr/local/share";
		paths+=GLib.Path.build_filename(GLib.Environment.get_home_dir(),".local","share");
		foreach(var path in paths) {
			this.refresh_entry(GLib.Path.build_filename(path,"applications"));
		}
	}

	private void refresh_entry(string path) {
	
		FileEnumerator enumerator;
		FileInfo info_file;
		string full_path;
		FileType typeinfo;
	
		var directory = File.new_for_path(path);
		try {
			 enumerator = directory.enumerate_children(FileAttribute.STANDARD_NAME+","+FileAttribute.STANDARD_TYPE,FileQueryInfoFlags.NOFOLLOW_SYMLINKS,null);
		} catch (Error e) {
			return;
		}
	
		while ((info_file = enumerator.next_file(null)) != null) {
			full_path=Path.build_filename(path,info_file.get_name());
			typeinfo=info_file.get_file_type();
			if (typeinfo==FileType.DIRECTORY) {
				this.refresh_entry(full_path);
			} else {
				if (full_path.has_suffix(".desktop")) {
					var entry=new desktop_entry(full_path);
					var groups=entry.get_groups();
					if (groups!=null) {
						bool found=false;
						foreach(var element in this.entries) {
							if((element.entry_icon.equal(entry.entry_icon))&&(element.info.get_executable()==entry.info.get_executable())) {
								found=true;
								break;
							}
						}
						if (found==false) {
							this.entries.add(entry);
						}
					}
				}
			}
		}
	}
	
	public static int compare_entries (desktop_entry? a, desktop_entry? b) {
		return (a.entry_name.casefold().collate(b.entry_name.casefold()));
	}

	public Gee.List<desktop_entry> get_entries(string category) {
	
		var filtered_entries=new Gee.ArrayList<desktop_entry>();
		foreach(var element in this.entries) {
			if ((category=="")||(element.is_in_group(category))) {
				filtered_entries.add(element);
			}
		}
		filtered_entries.sort(desktop_entries.compare_entries);
		return filtered_entries;
	}
}
