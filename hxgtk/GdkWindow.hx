package hxgtk;

class GdkWindow
{
	@:allow(hxgtk.GtkWidget)
	private function new (handle:Dynamic)
	{
		__handle = handle;
	}
	
	public static inline function invalidateRect (window:GdkWindow, a:GtkAllocation, b:Bool) : Void
	{
		hxgtk_window_invalidaterect(window.__handle, a.__handle, b);
	}
	
	public static inline function processUpdates (window:GdkWindow, b:Bool) : Void
	{
		hxgtk_window_processupdates(window.__handle, b);
	}
	
	public inline function getMouseInfo () : { x:Int, y:Int, state:Int }
	{
		return { x: hxgtk_get_mouse_info_x(__handle), y: hxgtk_get_mouse_info_y(__handle), state: hxgtk_get_mouse_info_state(__handle) };
	}
	
	private var __handle : Dynamic;
	
	private static var hxgtk_window_invalidaterect : Dynamic->Dynamic->Bool->Void = Ndll.load("hx_GdkWindow_invalidateRect", 3);
	private static var hxgtk_window_processupdates : Dynamic->Bool->Void = Ndll.load("hx_GdkWindow_processUpdates", 2);
	private static var hxgtk_get_mouse_info_x : Dynamic->Int= Ndll.load("hx_GdkWindow_getMouseInfo_x", 1);
	private static var hxgtk_get_mouse_info_y : Dynamic->Int= Ndll.load("hx_GdkWindow_getMouseInfo_y", 1);
	private static var hxgtk_get_mouse_info_state : Dynamic->Int= Ndll.load("hx_GdkWindow_getMouseInfo_state", 1);
}
