package hxgtk;

class GdkGLContext
{
	@:allow(hxgtk.GtkWidget)
	private function new (handle:Dynamic)
	{
		__handle = handle;
	}
	
	@:allow(hxgtk.GdkGl)
	private var __handle : Dynamic;
}
