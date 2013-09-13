using GLib;
using Gee;
//using GIO-unix;

class desktop_entry {

	public  string entry_name;
	public  GLib.Icon entry_icon;

	public  string[]? entry_group;
	private GLib.DesktopAppInfo info;
	
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
}

class desktop {

	private Gee.List<desktop_entry> entries;
	public string[] categories;

	public desktop() {
		this.refresh_entries();
	}

	public void refresh_entries() {
	
		this.categories={};
	
		this.entries=new Gee.ArrayList<desktop_entry>();
		var paths=GLib.Environment.get_variable("XDG_DATA_DIRS").split(":");
		foreach(var path in paths) {
			this.refresh_entry(GLib.Path.build_filename(path,"applications"));
		}
		var home_entries=GLib.Path.build_filename(GLib.Environment.get_home_dir(),".local","share","applications");
		this.refresh_entry(home_entries);
		foreach(var element2 in categories) {
			GLib.stdout.printf("Categoria %s\n",element2);
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
					GLib.stdout.printf("Compruebo %s\n",full_path);
					var entry=new desktop_entry(full_path);
					if (entry.entry_group!=null) {
						this.entries.add(entry);
						
						bool found;
						foreach(var element in entry.entry_group) {
							found=false;
							foreach(var element2 in categories) {
								if(element==element2) {
									found=true;
									break;
								}
							}
							if (found==false) {
								categories+=element;
							}
						}
					}
				}
			}
		}
	}

}
