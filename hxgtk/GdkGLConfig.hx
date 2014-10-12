package hxgtk;

class GdkGLConfig
{	
	public function new (mode:Int)
	{
		__handle = hxgtk_glconfig_new(mode);
		
		ok = __handle != 0;
	}
	
	public var ok : Bool;

	@:allow(hxgtk.GtkWidget)
	private var __handle : Dynamic;
	
	private static var hxgtk_glconfig_new : Int->Dynamic = Ndll.load("hx_GdkGLConfig_new", 1);
}
