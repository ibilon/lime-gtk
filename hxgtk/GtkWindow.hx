package hxgtk;

class GtkWindow extends GtkContainer
{
	public inline static var TOPLEVEL : Int = 0;
	
	public function new (type:Int)
	{
		__handle = hxgtk_window_new(type);
	}
	
	public inline function setDefaultSize (width:Int, height:Int) : Void
	{
		hxgtk_window_setdefaultsize(__handle, width, height);
	}
	
	private static var hxgtk_window_new : Int->Dynamic = Ndll.load("hx_GtkWindow_new", 1);
	private static var hxgtk_window_setdefaultsize : Dynamic->Int->Int->Void = Ndll.load("hx_GtkWindow_setDefaultSize", 3);
}
