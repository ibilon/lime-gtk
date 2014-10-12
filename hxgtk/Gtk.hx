package hxgtk;

class Gtk
{
	public static inline function init (name:String) : Void
	{
		hxgtk_init(name);
	}
	
	public static inline function main () : Bool
	{
		return hxgtk_main();
	}
	
	public static inline function mainQuit () : Void
	{
		hxgtk_mainquit();
	}
	
	private static var hxgtk_init : String->Void = Ndll.load("hx_Gtk_init", 1);
	private static var hxgtk_main : Void->Bool = Ndll.load("hx_Gtk_main", 0);
	private static var hxgtk_mainquit : Void->Void = Ndll.load("hx_Gtk_mainQuit", 0);
} 
