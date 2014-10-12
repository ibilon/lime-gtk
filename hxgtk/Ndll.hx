package hxgtk;

class Ndll
{
	public static function __init__ ()
	{
		load("neko_init", 5)("", [], null, true, false);
	}
	
	public static inline function load (name:String, args:Int)
	{
		return neko.Lib.load('ndll/$arch/hxgtk$debug', name, args);
	}
	
	public static inline function clearScreen()
	{
		hxgtk_clear_screen();
	}
	
	private static inline var arch : String = "Linux64";
	private static inline var debug : String = "-debug";
	
	private static var hxgtk_clear_screen : Void->Void = load("hx_clearScreen", 0);
}
