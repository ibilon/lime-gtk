package hxgtk;

class G
{
	public static inline function timeoutAdd(time:Float, fn:Void->Bool) : Void
	{
		hxgtk_timeoutadd(time, fn);
	}
	
	private static var hxgtk_timeoutadd : Float->(Void->Bool)->Void = Ndll.load("hx_G_timeoutAdd", 2);
}
