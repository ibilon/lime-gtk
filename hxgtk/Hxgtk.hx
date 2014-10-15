package hxgtk;

class Hxgtk
{
	public static inline function clearScreen () : Void
	{
		hxgtk_clear_screen();
	}
	
	public static inline function getTime () : Float
	{
		return hxgtk_get_time();
	}
	
	private static var hxgtk_clear_screen : Void->Void = Ndll.load("hx_clearScreen", 0);
	private static var hxgtk_get_time : Void->Float = Ndll.load("hx_getTime", 0);
}
