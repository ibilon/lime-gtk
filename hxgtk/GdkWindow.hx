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
	
	private var __handle : Dynamic;
	
	private static var hxgtk_window_invalidaterect : Dynamic->Dynamic->Bool->Void = Ndll.load("hx_GdkWindow_invalidateRect", 3);
	private static var hxgtk_window_processupdates : Dynamic->Bool->Void = Ndll.load("hx_GdkWindow_processUpdates", 2);
}
