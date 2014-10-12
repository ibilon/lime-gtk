package hxgtk;

class GtkWidget
{
	public var allocation(get, never) : GtkAllocation;
	private inline function get_allocation () : GtkAllocation
	{
		var h = hxgtk_widget_getallocation(__handle);
		return new GtkAllocation(h);
	}
	
	public var window(get, never) : GdkWindow;
	private inline function get_window () : GdkWindow
	{
		var h = hxgtk_widget_getwindow(__handle);
		return new GdkWindow(h);
	}
	
	public var width(get, never) : Int;
	private inline function get_width () : Int
	{
		return hxgtk_widget_getwidth(__handle);
	}
	
	public var height(get, never) : Int;
	private inline function get_height () : Int
	{
		return hxgtk_widget_getheight(__handle);
	}
	
	public inline function connect (event:String, fn:Void->Void) : Void
	{
		hxgtk_widget_connect(__handle, event, fn);
	}
	public inline function connectExpose (fn:Void->Bool) : Void
	{
		hxgtk_widget_connectexpose(__handle, "expose-event", fn);
	}
	public inline function connectConfigure (fn:Void->Bool) : Void
	{
		hxgtk_widget_connectconfigure(__handle, "configure-event", fn);
	}
	
	public inline function connectSwapped (event:String, fn:Void->Void) : Void
	{
		hxgtk_widget_connectswapped(__handle, event, fn);
	}
	
	public inline function getGlContext () : GdkGLContext
	{
		var h = hxgtk_widget_getglcontext(__handle);
		return new GdkGLContext(h);
	}
	
	public inline function getGlDrawable () : GdkGLDrawable
	{
		var h = hxgtk_widget_getgldrawable(__handle);
		return new GdkGLDrawable(h);
	}
	
	public inline function setGlCapability (config:GdkGLConfig, a:Dynamic, b:Bool, type:Int) : Bool
	{
		return hxgtk_widget_setglcapability(__handle, config.__handle, a, b, type);
	}
	
	public inline function setEvents (event:Int) : Void
	{
		hxgtk_widget_setevents(__handle, event);
	}
	
	public inline function show () : Void
	{
		hxgtk_widget_show(__handle);
	}
	
	public inline function showAll () : Void
	{
		hxgtk_widget_showall(__handle);
	}
	
	private var __handle : Dynamic;
	
	private static var hxgtk_widget_getallocation : Dynamic->Dynamic = Ndll.load("hx_GtkWidget_getAllocation", 1);
	private static var hxgtk_widget_getwindow : Dynamic->Dynamic = Ndll.load("hx_GtkWidget_getWindow", 1);
	private static var hxgtk_widget_getwidth : Dynamic->Int = Ndll.load("hx_GtkWidget_getWidth", 1);
	private static var hxgtk_widget_getheight : Dynamic->Int = Ndll.load("hx_GtkWidget_getHeight", 1);
	private static var hxgtk_widget_connect : Dynamic->String->(Void->Void)->Void = Ndll.load("hx_GtkWidget_connect", 3);
	private static var hxgtk_widget_connectconfigure : Dynamic->String->(Void->Void)->Void = Ndll.load("hx_GtkWidget_connect_configure", 3);
	private static var hxgtk_widget_connectexpose : Dynamic->String->(Void->Void)->Void = Ndll.load("hx_GtkWidget_connect_expose", 3);
	private static var hxgtk_widget_connectswapped : Dynamic->String->(Void->Void)->Void = Ndll.load("hx_GtkWidget_connectSwapped", 3);
	private static var hxgtk_widget_getglcontext : Dynamic->Dynamic = Ndll.load("hx_GtkWidget_getGlContext", 1);
	private static var hxgtk_widget_getgldrawable : Dynamic->Dynamic = Ndll.load("hx_GtkWidget_getGlDrawable", 1);
	private static var hxgtk_widget_setglcapability : Dynamic->Dynamic->Dynamic->Bool->Int->Bool = Ndll.load("hx_GtkWidget_setGlCapability", 5);
	private static var hxgtk_widget_setevents : Dynamic->Int->Void = Ndll.load("hx_GtkWidget_setEvents", 2);
	private static var hxgtk_widget_show : Dynamic->Void = Ndll.load("hx_GtkWidget_show", 1);
	private static var hxgtk_widget_showall : Dynamic->Void = Ndll.load("hx_GtkWidget_showAll", 1);
}
