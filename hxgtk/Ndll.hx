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
	
	
	
	private static inline var arch : String = "Linux64";
	private static inline var debug : String = "-debug";
}
