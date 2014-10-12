package hxgtk;

class GdkGLDrawable
{
	@:allow(hxgtk.GtkWidget)
	private function new (handle:Dynamic)
	{
		__handle = handle;
	}
	
	public inline function swap ()
	{
		hxgtk_swap(__handle);
	}
	
	@:allow(hxgtk.GdkGl)
	private var __handle : Dynamic;
	
	private static var hxgtk_swap : Dynamic->Void = Ndll.load("hx_GdkGLDrawable_swap", 1);
}
